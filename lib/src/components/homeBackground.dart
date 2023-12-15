import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimateGradient(
      primaryBegin: Alignment.topLeft,
      primaryEnd: Alignment.topRight,
      secondaryBegin: Alignment.bottomRight,
      secondaryEnd: Alignment.bottomLeft,
      primaryColors: const [
        Colors.pink,
        Colors.pinkAccent,
        Colors.white,
      ],
      secondaryColors: const [
        Colors.white,
        Colors.blueAccent,
        Colors.blue,
      ],
      child: child,
    );
  }
}
