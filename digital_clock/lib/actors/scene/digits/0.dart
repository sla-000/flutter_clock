import 'package:digital_clock/actors/scene/manna.dart';
import 'package:digital_clock/actors/scene/scene.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void set0(List<Actor> children) {
  for (int q = 200; q <= kSizeX - 200; q += 50) {
    children.add(Manna(
      name: '0t-$q',
      position: Vector(x: q.toDouble(), y: 200),
    ));

    children.add(Manna(
      name: '0b-$q',
      position: Vector(x: q.toDouble(), y: kSizeY - 200),
    ));
  }

  for (int q = 200; q <= kSizeY - 200; q += 50) {
    children.add(Manna(
      name: '0l-$q',
      position: Vector(x: 200, y: q.toDouble()),
    ));

    children.add(Manna(
      name: '0r-$q',
      position: Vector(x: kSizeX - 200, y: q.toDouble()),
    ));
  }
}
