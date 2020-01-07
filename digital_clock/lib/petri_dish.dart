import 'dart:async';

import 'package:digital_clock/actors/cell/cell.dart';
import 'package:digital_clock/actors/init.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'actors/scene/scene.dart';
import 'engine/actor.dart';
import 'utils/assets.dart';
import 'utils/delta.dart';
import 'utils/fps.dart';

final Logger _log = Logger('PetriDish')..level = Level.FINEST;

const int kMinFrameDelta = 33;

class PetriDish extends StatefulWidget {
  const PetriDish({
    @required this.valueNotifier,
    this.calculateFps,
    this.name,
    Key key,
  }) : super(key: key);

  final ValueNotifier<int> valueNotifier;
  final bool calculateFps;
  final String name;

  @override
  _PetriDishState createState() => _PetriDishState();
}

class _PetriDishState extends State<PetriDish> {
  Scene scene;

  @override
  void initState() {
    super.initState();
    _log.finest(() => 'initState: key=${widget.key}');

    widget.valueNotifier.addListener(() {
      _log.finest(() =>
          'valueNotifier: key=${widget.key}, value=${widget.valueNotifier.value}');

      scene.setDigit(widget.valueNotifier.value);
    });
  }

  @override
  void dispose() {
    _log.finest(() => 'dispose: key=${widget.key}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Assets.instance.loaded,
      builder: (BuildContext context, bool loaded, Widget child) {
        if (!loaded) {
          return child;
        }

        scene ??= Scene();
        initBeforeDrawActors();

        if (widget.valueNotifier.value != null) {
          scene.setDigit(widget.valueNotifier.value);
        }

        return AspectRatio(
          aspectRatio: 1 / 2,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: ClipRect(
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

class _DrawingWidgetState extends State<DrawingWidget>
    with WidgetsBindingObserver {
  Delta delta = Delta();
  Fps fps;
  double lastFps = 0;
  Timer fpsDisplayTimer;
  final StreamController<void> updateDisplay =
      StreamController<void>.broadcast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.calculateFps ?? false) {
      fps = Fps();

      fpsDisplayTimer = Timer.periodic(const Duration(seconds: 10), (_) {
        final int cells = widget.scene.children.whereType<Cell>().length;
        debugPrint('fps=${lastFps.round()}, cells=$cells');
      });
    }

    updateDisplay.stream.listen((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    if (fpsDisplayTimer != null) {
      fpsDisplayTimer.cancel();
    }

    updateDisplay.close();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _log.finest(() => 'didChangeAppLifecycleState: resumed');
      delta.calculate(
        DateTime.now().millisecondsSinceEpoch,
        ignore: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int deltaMillis = delta.calculate(DateTime.now().millisecondsSinceEpoch);

    if (deltaMillis > kMinFrameDelta) {
      deltaMillis = kMinFrameDelta;
    }

    if (widget.calculateFps ?? false) {
      lastFps = fps.calculate(deltaMillis);
    }

    return CustomPaint(
      painter: PetriPainter(
        scene: widget.scene,
        delta: deltaMillis,
        updateDisplay: updateDisplay.sink,
      ),
      size: const Size(kSizeX, kSizeY),
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
    Visible.draw(canvas, scene);

    Future<void>(() {
      if (delta != 0) {
        scene.update(scene, delta.toDouble());
      }

      updateDisplay.add(null);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
