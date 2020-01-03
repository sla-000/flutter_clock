import 'package:digital_clock/actors/scene/0.dart';
import 'package:digital_clock/actors/scene/1.dart';
import 'package:digital_clock/actors/scene/7.dart';
import 'package:digital_clock/actors/scene/8.dart';
import 'package:digital_clock/actors/scene/cells.dart';
import 'package:digital_clock/actors/scene/manna.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger('Scene')..level = Level.FINEST;

const double kSizeX = 1000;
const double kSizeY = 2000;

class Scene extends Actor {
  Scene({
    @required String name,
  }) : super(
          name: 'scene-$name',
          position: Vector.zero(),
          size: Vector(x: kSizeX, y: kSizeY),
          image: null,
        ) {
    setCells(children);

    setDigit(0); // todo Remove
  }

  void setDigit(int digit) {
    assert(digit >= 0 && digit <= 9);
    final Map<int, void Function(List<Actor>)> digit2func =
        <int, void Function(List<Actor>)>{
      0: set0,
      1: set1,
      2: set0, // todo Digit function
      3: set1, // todo Digit function
      4: set0, // todo Digit function
      5: set1, // todo Digit function
      6: set0, // todo Digit function
      7: set7,
      8: set8,
      9: set1, // todo Digit function
    };

    children.removeWhere((Actor actor) => actor is Manna);

    digit2func[digit](children);
  }
}
