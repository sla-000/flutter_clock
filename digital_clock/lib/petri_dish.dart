import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'actor.dart';
import 'assets.dart' as assets;

final Logger _log = Logger('PetriDish')..level = Level.FINEST;

Cell cell;

class PetriDish extends StatefulWidget {
  const PetriDish({
    @required this.valueNotifier,
    Key key,
  }) : super(key: key);

  final ValueNotifier<int> valueNotifier;

  @override
  _PetriDishState createState() => _PetriDishState();
}

class _PetriDishState extends State<PetriDish> {
  @override
  void initState() {
    super.initState();
    _log.finest(() => 'initState: key=${widget.key}');

    widget.valueNotifier.addListener(() {
      _log.finest(() =>
      'initState: key=${widget.key}, value=${widget.valueNotifier.value}');
    });

//    _scheduleTick();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: assets.loaded,
      builder: (BuildContext context, bool loaded, Widget child) {
        if (!loaded) {
          return child;
        }

        cell = Cell(x: 0, y: 0);

        return AspectRatio(
          aspectRatio: 1 / 2,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              color: Colors.black,
              child: DrawingWidget(
                key: widget.key,
              ),
            ),
          ),
        );
      },
      child: Container(
        color: Colors.black,
        width: 50,
        height: 100,
      ),
    );
  }
}

class DrawingWidget extends StatefulWidget {
  const DrawingWidget({
    Key key,
  }) : super(key: key);

  @override
  _DrawingWidgetState createState() => _DrawingWidgetState();
}

final StreamController<void> updateDisplay = StreamController<void>.broadcast();

class _DrawingWidgetState extends State<DrawingWidget> {
  int lastMillis;
  final List<double> averaging = <double>[];
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
        stream: updateDisplay.stream,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          final int millis = DateTime
              .now()
              .millisecondsSinceEpoch;

          lastMillis ??= millis;
          final int delta = millis - lastMillis;
          lastMillis = millis;

          averaging.add(delta.toDouble());
          while (averaging.length > 10) {
            averaging.removeAt(0);
          }

          final double averageDelay =
              averaging.reduce((double a, double b) => a + b) /
                  averaging.length;

          if (counter++ >= 300) {
            counter = 0;
            debugPrint('averageDelay=$averageDelay');
          }

          return CustomPaint(
            painter: PetriPainter(delta),
            size: const Size(500, 1000),
          );
        });
  }
}

class PetriPainter extends CustomPainter {
  PetriPainter(this.delta);

  int delta;

  @override
  void paint(Canvas canvas, Size size) {
//    _log.finest(() => 'paint: size=$size');
    cell.draw(canvas);

    Future<void>(() {
      cell.update(cell, delta.toDouble());

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
