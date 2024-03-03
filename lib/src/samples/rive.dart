import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RivePage extends StatelessWidget {
  const RivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: orientation == Orientation.portrait
            ? AppBar(
                title: const Text('Rive animation'),
              )
            : null,
        body: const Center(
          child: PlayPauseAnimation(),
          // child: ExampleStateMachine(),
          // child: StateMachineSkills(),
          // child: EventStarRating(),
          // child: Spaceman(),
        ),
      );
    });
  }
}

class PlayPauseAnimation extends StatefulWidget {
  const PlayPauseAnimation({super.key});

  @override
  State<PlayPauseAnimation> createState() => _PlayPauseAnimationState();
}

class _PlayPauseAnimationState extends State<PlayPauseAnimation> {
  /// Controller for playback
  late RiveAnimationController _controller;

  /// Toggles between play and pause animation states
  void _togglePlay() => setState(() => _controller.isActive = !_controller.isActive);

  /// Tracks if the animation is playing by whether controller is running
  bool get isPlaying => _controller.isActive;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('idle');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlay,
      child: RiveAnimation.asset(
        'assets/off_road_car.riv',
        fit: BoxFit.cover,
        controllers: [_controller],
        // Update the play state when the widget's initialized
        onInit: (_) => setState(() {}),
      ),
    );
  }
}

/// An example showing how to drive two boolean state machine inputs.
class ExampleStateMachine extends StatefulWidget {
  const ExampleStateMachine({super.key});

  @override
  State<ExampleStateMachine> createState() => _ExampleStateMachineState();
}

class _ExampleStateMachineState extends State<ExampleStateMachine> {
  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<bool>? _hoverInput;
  SMIInput<bool>? _pressInput;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/rocket.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller = StateMachineController.fromArtboard(artboard, 'Button');
        if (controller != null) {
          artboard.addController(controller);
          _hoverInput = controller.findInput('Hover');
          _pressInput = controller.findInput('Press');
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _riveArtboard == null
          ? const SizedBox()
          : MouseRegion(
              onEnter: (_) => _hoverInput?.value = true,
              onExit: (_) => _hoverInput?.value = false,
              child: GestureDetector(
                onTapDown: (_) => _pressInput?.value = true,
                onTapCancel: () => _pressInput?.value = false,
                onTapUp: (_) => _pressInput?.value = false,
                child: Stack(
                  children: [
                    Rive(
                      fit: BoxFit.cover,
                      artboard: _riveArtboard!,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// An example showing how to drive a StateMachine via one numeric input.
class StateMachineSkills extends StatefulWidget {
  const StateMachineSkills({super.key});

  @override
  State<StateMachineSkills> createState() => _StateMachineSkillsState();
}

class _StateMachineSkillsState extends State<StateMachineSkills> {
  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<double>? _levelInput;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/skills.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'Designer\'s Test');
        if (controller != null) {
          artboard.addController(controller);
          _levelInput = controller.findInput('Level');
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _riveArtboard == null
            ? const SizedBox()
            : Stack(
                children: [
                  Positioned.fill(
                    child: Rive(
                      artboard: _riveArtboard!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    bottom: 32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          child: const Text('Beginner'),
                          onPressed: () => _levelInput?.value = 0,
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          child: const Text('Intermediate'),
                          onPressed: () => _levelInput?.value = 1,
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          child: const Text('Expert'),
                          onPressed: () => _levelInput?.value = 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// This example demonstrates how to retrieve custom properties set on a Rive
/// event, and update the UI accordingly.
class EventStarRating extends StatefulWidget {
  const EventStarRating({super.key});

  @override
  State<EventStarRating> createState() => _EventStarRatingState();
}

class _EventStarRatingState extends State<EventStarRating> {
  late StateMachineController _controller;

  @override
  void initState() {
    super.initState();
  }

  String ratingValue = 'Rating: 0';

  void onInit(Artboard artboard) async {
    _controller = StateMachineController.fromArtboard(artboard, 'State Machine 1')!;
    artboard.addController(_controller);

    _controller.addEventListener(onRiveEvent);
  }

  void onRiveEvent(RiveEvent event) {
    // Access custom properties defined on the event
    var rating = event.properties['rating'] as double;
    // Schedule the setState for the next frame, as an event can be
    // triggered during a current frame update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        ratingValue = 'Rating: $rating';
      });
    });
  }

  @override
  void dispose() {
    _controller.removeEventListener(onRiveEvent);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: RiveAnimation.asset(
              'assets/rating_animation.riv',
              onInit: onInit,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              ratingValue,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}

/// An example showing how to drive a StateMachine via a trigger and number
/// input.
class LiquidDownload extends StatefulWidget {
  const LiquidDownload({super.key});

  @override
  State<LiquidDownload> createState() => _LiquidDownloadState();
}

class _LiquidDownloadState extends State<LiquidDownload> {
  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<bool>? _start;
  SMIInput<double>? _progress;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/liquid_download.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller = StateMachineController.fromArtboard(artboard, 'Download');
        if (controller != null) {
          artboard.addController(controller);
          _start = controller.findInput('Download');
          _progress = controller.findInput('Progress');
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _riveArtboard == null
            ? const SizedBox()
            : GestureDetector(
                onTapDown: (_) => _start?.value = true,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Slider(
                      value: _progress!.value,
                      min: 0,
                      max: 100,
                      label: _progress!.value.round().toString(),
                      onChanged: (double value) => setState(() {
                        _progress!.value = value;
                      }),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Rive(
                        artboard: _riveArtboard!,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// An example showing how to drive a StateMachine via a trigger input.
class LittleMachine extends StatefulWidget {
  const LittleMachine({super.key});

  @override
  State<LittleMachine> createState() => _LittleMachineState();
}

class _LittleMachineState extends State<LittleMachine> {
  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  /// Message that displays when state has changed
  String stateChangeMessage = '';

  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<bool>? _trigger;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/little_machine.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller = StateMachineController.fromArtboard(
          artboard,
          'State Machine 1',
          onStateChange: _onStateChange,
        );
        if (controller != null) {
          artboard.addController(controller);
          _trigger = controller.findInput('Trigger 1');
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  /// Do something when the state machine changes state
  void _onStateChange(String stateMachineName, String stateName) => setState(
        () => stateChangeMessage = 'State Changed in $stateMachineName to $stateName',
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _riveArtboard == null
              ? const SizedBox()
              : GestureDetector(
                  onTapDown: (_) => _trigger?.value = true,
                  child: Rive(
                    artboard: _riveArtboard!,
                    fit: BoxFit.cover,
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                stateChangeMessage,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

extension on Offset {
  Offset clamp({
    required double l,
    required double t,
    required double r,
    required double b,
  }) {
    return Offset(dx.clamp(l, r), dy.clamp(t, b));
  }
}

class Spaceman extends StatefulWidget {
  const Spaceman({super.key});

  @override
  State<Spaceman> createState() => _SpacemanState();
}

class _SpacemanState extends State<Spaceman> {
  StateMachineController? stateMachine;

  SMIInput<double>? numX;
  SMIInput<double>? numY;
  SMIInput<double>? numSize;

  var target = Offset.zero;

  void onInit(Artboard artboard) async {
    stateMachine = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    )!;
    artboard.addController(stateMachine!);
    numX = stateMachine!.findInput('numX');
    numY = stateMachine!.findInput('numY');
    numSize = stateMachine!.findInput('numSize');

    // Prepared to redraw.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return LayoutBuilder(builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        // From 320px to 800px, scale the numSize input on a scale of 0-100%
        if (numSize != null) {
          const resizeRange = 800 - 320;
          numSize!.value = ((800 - maxWidth) / resizeRange * 100).clamp(0, 100);
        }

        return Listener(
          onPointerMove: (event) {
            if (numX != null && numY != null) {
              target = (target + event.delta).clamp(
                l: -maxWidth / 2,
                t: -maxHeight / 2,
                r: maxWidth / 2,
                b: maxHeight / 2,
              );

              numX!.value = ((target.dx + maxWidth / 2) / maxWidth * 100).clamp(1, 99);
              numY!.value =
                  (100 - (target.dy + maxHeight / 2) / maxHeight * 100).clamp(1, 99);
            }
          },
          child: RiveAnimation.asset(
            'assets/spaceman.riv',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            onInit: onInit,
          ),
        );
      });
    });
  }
}
