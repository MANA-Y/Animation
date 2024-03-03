import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

const style = TextStyle(
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
);

class FlutterAnimatePage extends StatefulWidget {
  const FlutterAnimatePage({super.key});

  @override
  State<FlutterAnimatePage> createState() => _FlutterAnimatePageState();
}

class _FlutterAnimatePageState extends State<FlutterAnimatePage> {
  var isBoring = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isBoring
            ? const Text('Flutter SDK animation')
            : const Text('flutter_animate'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isBoring = !isBoring;
          });
        },
        child: const Icon(Icons.change_circle_outlined),
      ),
      body: Container(
        color: Colors.black,
        child: isBoring
            ? const Explicit(
                Text(
                  'Explicit',
                  style: style,
                ),
              )
            : const Short(
                Text(
                  'Animate',
                  style: style,
                ),
              ),
      ),
    );
  }
}

class Explicit extends StatefulWidget {
  final Widget child;

  const Explicit(
    this.child, {
    super.key,
  });

  @override
  State<Explicit> createState() => _ExplicitState();
}

class _ExplicitState extends State<Explicit> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _shade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    _shade = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.500,
          curve: Curves.ease,
        ),
      ),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => ScaleTransition(
              scale: _scale,
              child: Opacity(
                opacity: _shade.value,
                child: child!,
              ),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Short extends StatelessWidget {
  final Widget child;

  const Short(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Animate(
        effects: [
          FadeEffect(
            curve: Curves.ease,
            duration: 1.seconds,
            begin: 0,
            end: 1,
          ),
          ScaleEffect(
            curve: Curves.ease,
            duration: 2.seconds,
            begin: const Offset(0.0, 0.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
        child: child,
      ),
    );
  }
}
