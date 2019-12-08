import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'actor.dart';
import 'assets.dart' as assets;
import 'delta.dart';
import 'fps.dart';

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

        scene = Cell(x: 100, y: 100);

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
    final int millis = DateTime
        .now()
        .millisecondsSinceEpoch;

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

//class Palette {
//  static const PaletteEntry white = BasicPalette.white;
//  static const PaletteEntry red = PaletteEntry(Color(0xFFFF0000));
//  static const PaletteEntry blue = PaletteEntry(Color(0xFF0000FF));
//}

//class Cell extends PositionComponent {
//  static const SPEED = 0.25;
//
//  Cell(double size) {
//    width = height = size;
//    anchor = Anchor.center;
//  }
//
//  @override
//  void resize(Size size) {
//    x = size.width / 2;
//    y = size.height / 2;
//
//    width = height = math.min(size.width, size.height) / 2;
//  }
//
//  @override
//  void render(Canvas c) {
//    prepareCanvas(c);
//
//    _drawActor(
//      c,
//      assets.bodyImage,
//      Offset(width / 2, height / 2),
//      Paint()..color = Colors.white,
//      scale: const Size(0.5, 0.5),
//      rotation: 0.1,
//    );
//  }
//
//  @override
//  void update(double t) {
//    angle += SPEED * t;
//    angle %= 2 * math.pi;
//  }
//}

//class MyGame extends BaseGame {
//  MyGame() {
//    add(Cell(64.0));
//  }
//
//  @override
//  void resize(ui.Size size) {
//    super.resize(size);
//
//    _log.finest(() => 'resize: size=$size');
//  }
//}
//
//void _drawActor(
//  Canvas canvas,
//  ui.Image image,
//  Offset offset,
//  Paint paint, {
//  Size scale = const Size(1.0, 1.0),
//  double rotation = 0,
//}) {
//  canvas.save();
//
//  canvas.translate(offset.dx, offset.dy);
//
//  canvas.rotate(rotation);
//
//  canvas.scale(scale.width, scale.height);
//
//  canvas.drawImage(image, Offset(-image.width / 2, -image.height / 2), paint);
//
//  _drawTail(canvas);
//
//  _drawEye(canvas);
//
//  canvas.restore();
//}

//void _drawTail(Canvas canvas) {
//  canvas.save();
//
//  canvas.translate(40, 40);
//
//  canvas.rotate(0);
//
//  canvas.scale(1, 1);
//
//  canvas.drawImage(
//    assets.tailImage,
//    Offset(0, 0),
//    Paint()
//      ..colorFilter = ColorFilter.mode(Colors.green[600], BlendMode.modulate),
//  );
//
//  canvas.restore();
//}
//
//void _drawEye(Canvas canvas) {
//  canvas.save();
//
//  canvas.translate(-18, -18);
//
//  canvas.rotate(3.14 / 4);
//
//  canvas.scale(1, 1);
//
//  canvas.drawImage(
//    assets.eyeImage,
//    Offset(-assets.eyeImage.width / 2, -assets.eyeImage.height / 2),
//    Paint(),
//  );
//
//  canvas.restore();
//}
