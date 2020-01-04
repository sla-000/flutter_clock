import 'package:digital_clock/actors/scene/digits/manna.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger('Utils')..level = Level.FINEST;

void mannaLine(
  List<Actor> children,
  Vector vector0,
  Vector vector1,
) {
  final Vector lineDelta = vector1 - vector0;

  final Vector line1 = lineDelta.reduceToLength(50);
  final double partsNum = lineDelta.length / line1.length;

  for (double q = 0; q <= partsNum; q++) {
    final Vector currentPoint = vector0 + line1 * q;

    children.add(Manna(
      name: 'l-$q',
      position: currentPoint,
    ));
  }
}

void circle(List<Actor> children, Vector center, double radius) {
  // todo circle
}
