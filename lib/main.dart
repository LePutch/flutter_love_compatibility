// ignore_for_file: library_private_types_in_public_api

import 'package:compatibilitehoroscope/src/ad_mob_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pulsator/pulsator.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import 'package:zodiac/zodiac.dart';
import './src/components/homeBackground.dart';
import 'package:animate_gradient/animate_gradient.dart';

import 'src/components/resultPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Animated Gradient',
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  String contenu = '. . .';
  String initial1 = '?';
  String initial2 = '?';
  DateTime selectedDateTime1 = DateTime.now();
  DateTime selectedDateTime2 = DateTime.now();
  TextEditingController firstNameController1 = TextEditingController();
  TextEditingController firstNameController2 = TextEditingController();
  bool areFieldsFilled = false;

  BannerAd? _bannerAd;

  @override
  void initState() {
    _createBannerAd();
    _createRewardedAd();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  RewardedAd? _rewardedAd;

  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId!,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => setState(() {
          _rewardedAd = ad;
        }),
        onAdFailedToLoad: (error) {
          setState(() {
            _rewardedAd = null;
          });
        },
      ),
    );
  }

  void _showRewardedAd(String name1, String name2) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createRewardedAd();

          // Naviguer vers la nouvelle page lorsque la publicité est fermée
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(
                  contenu: '${calculateCompatibility(name1, name2)}%'),
            ),
          );
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          _createRewardedAd();
        },
      );

      _rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        // Cette partie sera exécutée lorsque l'utilisateur aura gagné une récompense
      });
      _rewardedAd = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    areFieldsFilled = firstNameController1.text.isNotEmpty &&
        firstNameController2.text.isNotEmpty &&
        selectedDateTime1.year != DateTime.now().year &&
        selectedDateTime2.year != DateTime.now().year;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: HomeBackground(
        child: Stack(
          children: [
            const Positioned.fill(top: -450, child: Pulse()),
            HeaderSection(
              contenu: contenu,
              initial1: initial1,
              initial2: initial2,
            ),
            //bottom banner ad
            Positioned(
              bottom: 0,
              child: _bannerAd == null
                  ? Container()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: AdWidget(
                        ad: _bannerAd!,
                      ),
                    ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 500,
              left: MediaQuery.of(context).size.width / 2 - 110,
              child: ElevatedButton.icon(
                onPressed: areFieldsFilled
                    ? () {
                        if (firstNameController1.text.isNotEmpty &&
                            firstNameController2.text.isNotEmpty &&
                            selectedDateTime1 != DateTime.now() &&
                            selectedDateTime2 != DateTime.now()) {
                          setState(() {
                            String name1 = firstNameController1.text;
                            String name2 = firstNameController2.text;
                            Future.delayed(const Duration(seconds: 10), () {
                              setState(() {
                                contenu =
                                    '${calculateCompatibility(name1, name2)}%';
                              });
                            });

                            _showRewardedAd(name1, name2);
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Veuillez remplir tous les prénoms et dates de naissance.',
                              ),
                            ),
                          );
                        }
                      }
                    : null,
                icon: const Icon(Icons.calculate),
                label: const Text(
                  'Calculer la compatibilité',
                  style: TextStyle(fontSize: 16),
                ),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(10),
                  backgroundColor: MaterialStateProperty.all(areFieldsFilled
                      ? const Color.fromARGB(255, 158, 52, 66)
                      : Colors.grey),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 280,
              left: 20,
              child: CustomCard(
                selectedDateTime: selectedDateTime1,
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    selectedDateTime1 = dateTime;
                  });
                },
                name: 'Prénom 1',
                firstNameController: firstNameController1,
                onNameChanged: (value) {
                  setState(() {
                    initial1 = value.isNotEmpty ? value[0].toUpperCase() : '?';
                  });
                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 280,
              left: MediaQuery.of(context).size.width / 2 + 12,
              child: CustomCard(
                selectedDateTime: selectedDateTime2,
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    selectedDateTime2 = dateTime;
                  });
                },
                name: 'Prénom 2',
                firstNameController: firstNameController2,
                onNameChanged: (value) {
                  setState(() {
                    initial2 = value.isNotEmpty ? value[0].toUpperCase() : '?';
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Pulse extends StatelessWidget {
  const Pulse({super.key});

  @override
  Widget build(BuildContext context) {
    return const Pulsator(
      count: 5,
      duration: Duration(seconds: 10),
      fit: PulseFit.cover,
      style: PulseStyle(
        color: Color.fromARGB(255, 244, 54, 54),
        borderColor: Colors.white24,
        borderWidth: 5,
        pulseCurve: Curves.decelerate,
        opacityCurve: Curves.easeOut,
        gradientStyle: PulseGradientStyle(
          startColor: Color.fromARGB(255, 131, 10, 10),
          start: 0.5,
          reverseColors: true,
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final String contenu;
  final String initial1;
  final String initial2;

  const HeaderSection({
    Key? key,
    required this.contenu,
    required this.initial1,
    required this.initial2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Image.asset(
                'assets/images/gradient_heart_outlined.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: MediaQuery.of(context).padding.top + kToolbarHeight + 150,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              contenu,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: MediaQuery.of(context).padding.top + kToolbarHeight + 110,
          child: const Align(
            alignment: Alignment.topCenter,
            child: Text(
              '=',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: MediaQuery.of(context).padding.top + kToolbarHeight + 70,
          child: const Align(
            alignment: Alignment.topCenter,
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: MediaQuery.of(context).padding.top + kToolbarHeight + 70,
          left: -120,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              initial1,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: MediaQuery.of(context).padding.top + kToolbarHeight + 70,
          left: 120,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              initial2,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //function for time
}

class CustomCard extends StatefulWidget {
  final DateTime selectedDateTime;
  final void Function(DateTime) onDateTimeChanged;
  final TextEditingController firstNameController;
  final void Function(String) onNameChanged;
  final String name;

  const CustomCard({
    Key? key,
    required this.selectedDateTime,
    required this.onDateTimeChanged,
    required this.firstNameController,
    required this.onNameChanged,
    required this.name,
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isDateSelected = false;

  @override
  Widget build(BuildContext context) {
    String zodiacSign =
        Zodiac().getZodiac(widget.selectedDateTime.toLocal().toString());
    String imageAssetPath = getZodiacImage(zodiacSign);

    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 32.0,
      child: Card(
        elevation: 0,
        color: const Color.fromARGB(0, 38, 0, 21),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              width: double.infinity,
              height: 70.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    isDateSelected
                        ? (zodiacSign.isEmpty
                            ? 'assets/images/noidea.png'
                            : imageAssetPath)
                        : 'assets/images/noidea.png',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextField(
                        controller: widget.firstNameController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: widget.name,
                          hintStyle: const TextStyle(color: Colors.white30),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          widget.onNameChanged(value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TimePickerSpinnerPopUp(
                    mode: CupertinoDatePickerMode.date,
                    initTime: widget.selectedDateTime,
                    barrierColor: Colors.black12,
                    minuteInterval: 1,
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    cancelText: 'Cancel',
                    confirmText: 'OK',
                    pressType: PressType.singlePress,
                    timeFormat: 'dd/MM/yyyy',
                    textStyle: const TextStyle(color: Colors.white),
                    iconSize: 18,
                    timeWidgetBuilder: (dateTime) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cake_rounded,
                              color: Colors.white,
                              size: 18.0,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              '${dateTime.day}/${dateTime.month}/${dateTime.year}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                    onChange: (dateTime) {
                      setState(() {
                        isDateSelected = true;
                        widget.onDateTimeChanged(dateTime);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getZodiacImage(String zodiacSign) {
    return zodiacSign.isEmpty
        ? 'assets/images/noidea.png'
        : 'assets/images/$zodiacSign.png';
  }
}

int sumOfLetters(String name) {
  return name
      .split('')
      .map((char) => char.codeUnitAt(0) - 64)
      .reduce((a, b) => a + b);
}

int calculateCompatibility(String name1, String name2) {
  if (name1 == 'Jérémy' && name2 == 'Océane' ||
      name1 == 'Océane' && name2 == 'Jérémy') {
    return 100;
  }
  if (name1 == 'Jérémy' && name2 == 'Adrian' ||
      name1 == 'Adrian' && name2 == 'Jérémy') {
    return 100;
  }
  if (name1 == 'Jérémy' && name2 == 'Lucas' ||
      name1 == 'Lucas' && name2 == 'Jérémy') {
    return 100;
  }
  if (name1 == 'Jérémy' && name2 == 'William' ||
      name1 == 'William' && name2 == 'Jérémy') {
    return 100;
  }

  int value1 = _calculateValue(name1);
  int value2 = _calculateValue(name2);

  int totalValue = value1 + value2;

  int compatibility = ((totalValue % 100) * 100) ~/ 100;

  return compatibility;
}

int _calculateValue(String name) {
  int sum = 0;
  for (int i = 0; i < name.length; i++) {
    sum += _charToValue(name[i].toUpperCase());
  }
  return sum;
}

int _charToValue(String char) {
  return char.codeUnitAt(0) - 'A'.codeUnitAt(0) + 1;
}
