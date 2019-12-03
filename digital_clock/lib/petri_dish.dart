import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  int _frameCallbackId;

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

  void _scheduleTick() {
    _frameCallbackId = SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _unscheduleTick() {
    SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackId);
  }

  void _tick(Duration timestamp) {
    if (!mounted) {
      return;
    }
    _scheduleTick();
    _update(timestamp);

    setState(() {});
  }

  void _update(Duration timestamp) {}
}

class PetriPainter extends CustomPainter {
  int lastMillis;

  @override
  void paint(Canvas canvas, Size size) {
//    _log.finest(() => 'paint: size=$size');

    int delta = 0;

    final int currentMillis = DateTime
        .now()
        .toUtc()
        .millisecondsSinceEpoch;
    if (lastMillis != null) {
      delta = currentMillis - lastMillis;
    }
    lastMillis = currentMillis;

    canvas.drawRect(
        const Rect.fromLTWH(3.0, 3.0, 500.0 - 6.0, 1000.0 - 6.0), Paint());

    _drawActor(
      canvas,
      assets.bodyImage,
      Offset(size.width / 2, size.height / 2),
      Paint()..color = Colors.white,
      scale: const Size(3.0, 3.0),
      rotation: delta / 1000 * 0.1,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
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
}
