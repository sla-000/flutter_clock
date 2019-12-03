import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'assets.dart' as assets;

final Logger _log = Logger('PetriDish')..level = Level.FINEST;

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
  MyGame myGame = MyGame();

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

        return AspectRatio(
          aspectRatio: 1 / 2,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: myGame.widget,
          ),
        );

        return CustomPaint(
          painter: PetriPainter(),
          size: const Size(500, 1000),
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

class PetriPainter extends CustomPainter {
  int lastMillis;

  @override
  void paint(Canvas canvas, Size size) {
//    _log.finest(() => 'paint: size=$size');

    canvas.drawRect(
        const Rect.fromLTWH(3.0, 3.0, 500.0 - 6.0, 1000.0 - 6.0), Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Palette {
  static const PaletteEntry white = BasicPalette.white;
  static const PaletteEntry red = PaletteEntry(Color(0xFFFF0000));
  static const PaletteEntry blue = PaletteEntry(Color(0xFF0000FF));
}

class Cell extends PositionComponent {
  static const SPEED = 0.25;

  Cell(double size) {
    width = height = size;
    anchor = Anchor.center;
  }

  @override
  void resize(Size size) {
    x = size.width / 2;
    y = size.height / 2;

    width = height = math.min(size.width, size.height) / 2;
  }

  @override
  void render(Canvas c) {
    prepareCanvas(c);

    _drawActor(
      c,
      assets.bodyImage,
      Offset(width / 2, height / 2),
      Paint()
        ..color = Colors.white,
      scale: const Size(0.5, 0.5),
      rotation: 0.1,
    );
  }

  @override
  void update(double t) {
    angle += SPEED * t;
    angle %= 2 * math.pi;
  }
}

class MyGame extends BaseGame {
  MyGame() {
    add(Cell(64.0));
  }

  @override
  void resize(ui.Size size) {
    super.resize(size);

    _log.finest(() => 'resize: size=$size');
  }
}

void _drawActor(Canvas canvas,
    ui.Image image,
    Offset offset,
    Paint paint, {
      Size scale = const Size(1.0, 1.0),
      double rotation = 0,
    }) {
  canvas.save();

  canvas.translate(offset.dx, offset.dy);

  canvas.rotate(rotation);

  canvas.scale(scale.width, scale.height);

  canvas.drawImage(image, Offset(-image.width / 2, -image.height / 2), paint);

  _drawTail(canvas);

  _drawEye(canvas);

  canvas.restore();
}

void _drawTail(Canvas canvas) {
  canvas.save();

  canvas.translate(40, 40);

  canvas.rotate(0);

  canvas.scale(1, 1);

  canvas.drawImage(
    assets.tailImage,
    Offset(0, 0),
    Paint()
      ..colorFilter = ColorFilter.mode(Colors.green[600], BlendMode.modulate),
  );

  canvas.restore();
}

void _drawEye(Canvas canvas) {
  canvas.save();

  canvas.translate(-18, -18);

  canvas.rotate(3.14 / 4);

  canvas.scale(1, 1);

  canvas.drawImage(
    assets.eyeImage,
    Offset(-assets.eyeImage.width / 2, -assets.eyeImage.height / 2),
    Paint(),
  );

  canvas.restore();
}
