import 'package:digital_clock/actors/scene/digits/utils.dart';
import 'package:digital_clock/actors/scene/scene.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void set1(List<Actor> children) {
  mannaLine(
    children,
    Vector(x: kSizeX / 2, y: 200),
    Vector(x: kSizeX / 2, y: kSizeY - 200),
  );

  mannaLine(
    children,
    Vector(x: kSizeX / 2, y: 200),
    Vector(x: kSizeX / 2 - 200, y: 400),
  );
}
