import 'package:digital_clock/actors/scene/manna.dart';
import 'package:digital_clock/actors/scene/scene.dart';
import 'package:digital_clock/actors/scene/utils.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void set7(List<Actor> children) {
  for (int q = 200; q <= kSizeX - 200; q += 50) {
    children.add(Manna(
      name: '7t-$q',
      position: Vector(x: q.toDouble(), y: 200),
    ));
  }

  mannaLine(
    children,
    Vector(x: kSizeX - 200, y: 200),
    Vector(x: kSizeX / 2, y: kSizeY / 2),
  );

  for (int q = (kSizeY / 2).round(); q <= kSizeY - 200; q += 50) {
    children.add(Manna(
      name: '7b-$q',
      position: Vector(x: kSizeX / 2, y: q.toDouble()),
    ));
  }
}
