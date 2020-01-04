import 'package:digital_clock/actors/scene/scene.dart';
import 'package:digital_clock/actors/scene/utils.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void set4(List<Actor> children) {
  mannaLine(
    children,
    Vector(x: kSizeX - 200, y: 200),
    Vector(x: kSizeX - 200, y: kSizeY - 200),
  );

  mannaLine(
    children,
    Vector(x: kSizeX - 200, y: 200),
    Vector(x: 200, y: kSizeY / 2),
  );

  mannaLine(
    children,
    Vector(x: 200, y: kSizeY / 2),
    Vector(x: kSizeX - 200, y: kSizeY / 2),
  );
}
