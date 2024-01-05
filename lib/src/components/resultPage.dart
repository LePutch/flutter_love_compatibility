import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:spring/spring.dart';
import './homeBackground.dart';

class ResultPage extends StatefulWidget {
  final String contenu;

  ResultPage({required this.contenu});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  late final AnimationController _controller1;
  late final AnimationController _controller2;
  late final AnimationController _controller3;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000));
    _controller2 = AnimationController(vsync: this);
    _controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeBackground(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Premier Lottie avec délai de 0 secondes
            Container(
              child: Lottie.asset(
                height: double.infinity,
                width: double.infinity,
                'assets/lotties/heart.json',
                fit: BoxFit.cover,
                repeat: false,
                controller: _controller1,
                onLoaded: (composition) {
                  _controller1
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ),

            // Deuxième Lottie avec délai de 4 secondes
            FutureBuilder(
              future: Future.delayed(const Duration(seconds: 4)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Lottie.asset(
                      'assets/lotties/heart1.json',
                      fit: BoxFit.cover,
                      repeat: false,
                      controller: _controller2,
                      onLoaded: (composition) {
                        _controller2
                          ..duration = composition.duration
                          ..forward();
                      },
                    ),
                  );
                } else {
                  return Container(); // Ou un widget de chargement
                }
              },
            ),

            // Troisième Lottie avec délai de 6 secondes
            FutureBuilder(
              future: Future.delayed(const Duration(seconds: 5)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Spring.shake(
                    child: RippleAnimation(
                      color: Colors.deepOrange,
                      delay: const Duration(milliseconds: 300),
                      repeat: true,
                      minRadius: 100,
                      ripplesCount: 8,
                      duration: const Duration(milliseconds: 3000),
                      child: Container(
                        child: Lottie.asset(
                          'assets/lotties/heartPop.json',
                          fit: BoxFit.cover,
                          controller: _controller3,
                          onLoaded: (composition) {
                            _controller3
                              ..duration = composition.duration
                              ..forward();
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(); // Ou un widget de chargement
                }
              },
            ),

            FutureBuilder(
              future: Future.delayed(const Duration(seconds: 5)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Spring.shake(
                    child: Text(
                      widget.contenu,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  );
                } else {
                  return Container(); // Ou un widget de chargement
                }
              },
            ),

            FutureBuilder(
              future: Future.delayed(const Duration(seconds: 8)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Spring.fadeIn(
                    child: Padding(
                      //doit être en bas de la page

                      padding: const EdgeInsets.only(top: 600),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.replay),
                        label: const Text(
                          'Refaire le test',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(10),
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 158, 52, 66),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                } else {
                  return Container(); // Ou un widget de chargement
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
