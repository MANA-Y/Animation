import 'dart:async';
import 'dart:ui' as ui;

import 'package:animation/src/helpers/helpers.dart';
import 'package:flutter/material.dart';

class ExplicitPage extends StatelessWidget {
  const ExplicitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explicit animation'),
      ),
      body: Container(
        color: Colors.black,
        child: const Center(child: Jumping()),
      ),
    );
  }
}

class Jumping extends StatefulWidget {
  const Jumping({super.key});

  @override
  State<Jumping> createState() => _JumpingCharacterState();
}

class _JumpingCharacterState extends State<Jumping>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _jumpAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });

    // Высота прыжка
    _jumpAnimation = Tween(begin: 0.0, end: 120.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    ));

    // Изменение размера
    _sizeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 100.0, end: 300.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 300.0, end: 0.0), weight: 50),
    ]).animate(_controller);

    // Изменение цвета
    _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.white,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5),
      reverseCurve: const Interval(0.5, 1.0),
    ));

    _controller.forward().then((value) => _controller.animateTo(0.5)); // Повторять анимацию
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -_jumpAnimation.value),
      child: SizedBox(
        width: _sizeAnimation.value,
        height: _sizeAnimation.value,
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return RadialGradient(
              center: Alignment.center,
              radius: 1.0,
              colors: [_colorAnimation.value!, Colors.transparent],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: const FlutterLogo(
            style: FlutterLogoStyle.stacked,
          ),
        ),
      ),
    );
  }
}