import 'dart:ui' as ui;

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
  @override
  void initState() {
    super.initState();
    _log.finest(() => 'initState: key=${widget.key}');

    widget.valueNotifier.addListener(() {
      _log.finest(() =>
          'initState: key=${widget.key}, value=${widget.valueNotifier.value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: ValueListenableBuilder<bool>(
        valueListenable: assets.loaded,
        builder: (BuildContext context, bool loaded, Widget child) {
          if (!loaded) {
            return child;
          }

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
      ),
    );
  }
}

class PetriPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _log.finest(() => 'paint: size=$size');

    canvas.drawRect(
        const Rect.fromLTWH(3.0, 3.0, 500.0 - 6.0, 1000.0 - 6.0), Paint());

    canvas.drawLine(
      const Offset(0, 0),
      const Offset(200, 0),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.grey,
    );

    canvas.drawLine(
      const Offset(200, 0),
      const Offset(200, 200),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.grey,
    );

    canvas.drawLine(
      const Offset(200, 200),
      const Offset(0, 200),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.grey,
    );

    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, 0),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.grey,
    );

    _drawActor(
      canvas,
      assets.bodyImage,
      const Offset(100.0, 200.0),
      Paint()..color = Colors.white,
      scale: const Size(1.0, 1.0),
      rotation: 0.3,
    );

    _drawActor(
      canvas,
      assets.eyeImage,
      const Offset(90.0, 190.0),
      Paint()..color = Colors.white,
      scale: const Size(1.0, 1.0),
      rotation: 0.3,
    );

    _drawActor(
      canvas,
      assets.tailImage,
      const Offset(150.0, 250.0),
      Paint()
        ..colorFilter = ColorFilter.mode(Colors.blue[200], BlendMode.modulate),
      scale: const Size(1.0, 1.0),
      rotation: 0.3,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // todo Set to true to redraw every frame
  }

  void _drawActor(
    Canvas canvas,
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

    canvas.restore();
  }
}
