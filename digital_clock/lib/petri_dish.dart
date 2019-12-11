import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'assets.dart' as assets;
import 'engine/actor.dart';
import 'utils/delta.dart';
import 'utils/fps.dart';

final Logger _log = Logger('PetriDish')..level = Level.FINEST;

class PetriDish extends StatefulWidget {
  const PetriDish({
    @required this.valueNotifier,
    this.calculateFps,
    Key key,
  }) : super(key: key);

  final ValueNotifier<int> valueNotifier;
  final bool calculateFps;

  @override
  _PetriDishState createState() => _PetriDishState();
}

class _PetriDishState extends State<PetriDish> {
  Actor scene;

  @override
  void initState() {
    super.initState();
    _log.finest(() => 'initState: key=${widget.key}');

    widget.valueNotifier.addListener(() {
      _log.finest(() =>
          'valueNotifier: key=${widget.key}, value=${widget.valueNotifier.value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: assets.loaded,
      builder: (BuildContext context, bool loaded, Widget child) {
        if (!loaded) {
          return child;
        }

        scene = Scene();

        return AspectRatio(
          aspectRatio: 1 / 2,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              color: Colors.black,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: DrawingWidget(
                  key: widget.key,
                  scene: scene,
                  calculateFps: widget.calculateFps,
                ),
              ),
            ),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 1 / 2,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class DrawingWidget extends StatefulWidget {
  const DrawingWidget({
    this.calculateFps,
    this.scene,
    Key key,
  }) : super(key: key);

  final bool calculateFps;
  final Actor scene;

  @override
  _DrawingWidgetState createState() => _DrawingWidgetState();
}

class _DrawingWidgetState extends State<DrawingWidget> {
  int lastMillis;
  Delta delta = Delta();
  Fps fps;
  double lastFps = 0;
  Timer fpsDisplayTimer;
  final StreamController<void> updateDisplay =
      StreamController<void>.broadcast();

  @override
  void initState() {
    super.initState();

    if (widget.calculateFps ?? false) {
      fps = Fps();

      fpsDisplayTimer = Timer.periodic(Duration(seconds: 10), (_) {
        debugPrint('fps=${lastFps.round()}');
      });
    }

    updateDisplay.stream.listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    if (fpsDisplayTimer != null) {
      fpsDisplayTimer.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int millis = DateTime.now().millisecondsSinceEpoch;

    final int delta_ms = delta.calculate(millis);

    if (widget.calculateFps ?? false) {
      lastFps = fps.calculate(delta_ms);
    }

    return CustomPaint(
      painter: PetriPainter(
        scene: widget.scene,
        delta: delta_ms,
        updateDisplay: updateDisplay.sink,
      ),
      size: const Size(500, 1000),
    );
  }
}

class PetriPainter extends CustomPainter {
  PetriPainter({
    @required this.scene,
    @required this.delta,
    @required this.updateDisplay,
  });

  final Actor scene;
  final int delta;
  final Sink<void> updateDisplay;

  @override
  void paint(Canvas canvas, Size size) {
//    _log.finest(() => 'paint: size=$size');
    scene.draw(canvas);

    Future<void>(() {
      scene.update(scene, delta.toDouble());

      updateDisplay.add(null);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
