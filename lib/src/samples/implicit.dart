import 'dart:async';
import 'dart:ui' as ui;

import 'package:animation/src/helpers/helpers.dart';
import 'package:flutter/material.dart';

class ImplicitPage extends StatelessWidget {
  const ImplicitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit animation'),
      ),
      body: Container(
        color: Colors.black,
        child: const Sky(fireflies: 50),
      ),
    );
  }
}

class FireflyData {
  final double size;
  Alignment alignment;

  FireflyData()
      : size = randomClamp(10, 90),
        alignment = randomAlignment();

  void updateAlignment() => alignment = randomAlignment();
}

class Sky extends StatefulWidget {
  final int fireflies;

  const Sky({
    required this.fireflies,
    super.key,
  });

  @override
  State<Sky> createState() => _SkyState();
}

class _SkyState extends State<Sky> {
  final _fireflies = <FireflyData>[];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _makeSky();

    _timer = Timer.periodic(
      const Duration(milliseconds: 600),
      (timer) {
        if (mounted) {
          setState(() {
            for (final firefly in _fireflies) {
              firefly.updateAlignment();
            }
          });
        }
      },
    );
  }

  void _makeSky() {
    _fireflies.clear();
    for (int i = 0; i < widget.fireflies; i++) {
      _fireflies.add(FireflyData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Text(
            'Flutter',
            style: TextStyle(
              color: Colors.white,
              fontSize: 100,
              shadows: <Shadow>[
                Shadow(
                  blurRadius: 3.0,
                  color: Colors.white,
                ),
                Shadow(
                  blurRadius: 8.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        Stack(children: [
          for (final firefly in _fireflies)
            Positioned.fill(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 2400),
                curve: Curves.linear,
                alignment: firefly.alignment,
                child: CustomPaint(
                  size: Size(firefly.size, firefly.size),
                  painter: Painter(),
                ),
              ),
            ),
        ]),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    var path0 = Path()..fillType = PathFillType.nonZero;
    path0.moveTo(
      1 * w,
      0.5 * h,
    );
    path0.cubicTo(
      1 * w,
      0.7761424 * h,
      0.7761424 * w,
      1 * h,
      0.5 * w,
      1 * h,
    );
    path0.cubicTo(
      0.22385763 * w,
      1 * h,
      0.00000000000000005650439 * w,
      0.7761424 * h,
      0 * w,
      0.5 * h,
    );
    path0.cubicTo(
      -0.00000000000000005650439 * w,
      0.22385763 * h,
      0.22385763 * w,
      0.00000000000000005650439 * h,
      0.5 * w,
      0 * h,
    );
    path0.cubicTo(
      0.7761424 * w,
      0 * h,
      1 * w,
      0.22385763 * h,
      1 * w,
      0.5 * h,
    );
    path0.close();
    Paint paint0 = Paint();
    paint0.shader = ui.Gradient.radial(
      Offset(0 * w, 0 * h),
      0.0019880715 * w,
      const [
        Color(0x2BFFFFFF),
        Color(0x00FFFFFF),
      ],
      [
        0,
        1,
      ],
      TileMode.clamp,
      Matrix4(0.50003624, 194.50035, 0, 0, -194.50035, 0.50003624, 0, 0, 0, 0, 1, 0,
              0.5 * w, 0.5 * w, 0, 1)
          .storage,
      Offset(0 * w, 0 * h),
    );
    canvas.drawPath(path0, paint0);

    var path1 = Path()..fillType = PathFillType.nonZero;
    path1.moveTo(
      0.57654077 * w,
      0.5 * h,
    );
    path1.cubicTo(
      0.57654077 * w,
      0.5422723 * h,
      0.5422723 * w,
      0.57654077 * h,
      0.5 * w,
      0.57654077 * h,
    );
    path1.cubicTo(
      0.4577277 * w,
      0.57654077 * h,
      0.42345923 * w,
      0.5422723 * h,
      0.42345923 * w,
      0.5 * h,
    );
    path1.cubicTo(
      0.42345923 * w,
      0.4577277 * h,
      0.4577277 * w,
      0.42345923 * h,
      0.5 * w,
      0.42345923 * h,
    );
    path1.cubicTo(
      0.5422723 * w,
      0.42345923 * h,
      0.57654077 * w,
      0.4577277 * h,
      0.57654077 * w,
      0.5 * h,
    );
    path1.close();
    Paint paint1 = Paint();
    paint1.color = const Color(0xFFFFFFAA);
    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant Painter oldDelegate) {
    return false;
  }
}
