import 'package:digital_clock/actors/scene/digits/manna.dart';
import 'package:digital_clock/actors/scene/digits/utils.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void set1(List<Actor> children) {
//  mannaLine(
//    children,
//    Vector(x: kSizeX / 2, y: 200),
//    Vector(x: kSizeX / 2, y: kSizeY - 200),
//  );
//
//  mannaLine(
//    children,
//    Vector(x: kSizeX / 2, y: 200),
//    Vector(x: kSizeX / 2 - 200, y: 400),
//  );

  final Vector v0 = Vector(x: 900, y: 300);
  final Vector v1 = Vector(x: 900, y: 900);

  children.add(Manna(position: v0));
  children.add(Manna(position: v1));

  curve(children, v0, v1, 3, 0.5);
}
