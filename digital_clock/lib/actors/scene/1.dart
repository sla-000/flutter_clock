import 'package:digital_clock/actors/scene/manna.dart';
import 'package:digital_clock/actors/scene/scene.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void set1(List<Actor> children) {
  for (int q = 200; q <= kSizeY - 200; q += 50) {
    children.add(Manna(
      name: '1r-$q',
      position: Vector(x: kSizeX / 2, y: q.toDouble()),
    ));
  }
}
