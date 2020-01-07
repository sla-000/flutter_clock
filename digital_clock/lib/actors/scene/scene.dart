import 'package:digital_clock/actors/scene/cells.dart';
import 'package:digital_clock/actors/scene/digits/0.dart';
import 'package:digital_clock/actors/scene/digits/1.dart';
import 'package:digital_clock/actors/scene/digits/2.dart';
import 'package:digital_clock/actors/scene/digits/3.dart';
import 'package:digital_clock/actors/scene/digits/4.dart';
import 'package:digital_clock/actors/scene/digits/5.dart';
import 'package:digital_clock/actors/scene/digits/6.dart';
import 'package:digital_clock/actors/scene/digits/7.dart';
import 'package:digital_clock/actors/scene/digits/8.dart';
import 'package:digital_clock/actors/scene/digits/9.dart';
import 'package:digital_clock/actors/scene/digits/manna.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';
import 'package:flutter/painting.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger('Scene')..level = Level.FINEST;

const double kSizeX = 1000;
const double kSizeY = 2000;

class Scene extends Actor {
  Scene()
      : super(
          position: Vector.zero(),
          size: Vector(x: kSizeX, y: kSizeY),
        ) {
    initCells(children);
  }

  static const Map<int, void Function(List<Actor>)> digit2func =
      <int, void Function(List<Actor>)>{
    0: set0,
    1: set1,
    2: set2,
    3: set3,
    4: set4,
    5: set5,
    6: set6,
    7: set7,
    8: set8,
    9: set9,
  };

  void setDigit(int digit) {
    assert(digit >= 0 && digit <= 9);

    children.removeWhere((Actor actor) => actor is Manna);

    digit2func[digit](children);
  }
}

void drawScene(Canvas canvas, Actor actor) {
  return;
}
