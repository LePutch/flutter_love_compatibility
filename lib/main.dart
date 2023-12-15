// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pulsator/pulsator.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import 'package:zodiac/zodiac.dart';
import './src/components/homeBackground.dart';

void main() {
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

class _AppState extends State<App> {
  String contenu = '. . .';
  String initial1 = '?';
  String initial2 = '?';
  DateTime selectedDateTime1 = DateTime.now();
  DateTime selectedDateTime2 = DateTime.now();
  TextEditingController firstNameController1 = TextEditingController();
  TextEditingController firstNameController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeBackground(
        child: Stack(
          children: [
            const Positioned.fill(top: -450, child: Pulse()),
            HeaderSection(
              contenu: contenu,
              initial1: initial1,
              initial2: initial2,
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 500,
              left: MediaQuery.of(context).size.width / 2 - 100,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    contenu = '${Random().nextInt(101)}%';
                  });
                },
                child: const Text('Calculer la compatibilité'),
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
