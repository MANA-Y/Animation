import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transition animation'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go Second'),
          onPressed: () {
            Navigator.of(context).push(createRoute());
          },
        ),
      ),
    );
  }
}

Route createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const SecondScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second screen'),
      ),
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          color: Colors.white,
        ),
      ).animate(
        effects: [
          RotateEffect(duration: 2.seconds),
          ColorEffect(begin: Colors.red, end: Colors.blue, duration: 2.seconds),
        ],
        onComplete: (controller) => controller.forward(from: 0),
      ),
    );
  }
}
