import 'package:digital_clock/actors/scene/digits/manna.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger('Utils')..level = Level.FINEST;

Vector mannaLine({
  List<Actor> children,
  Vector startPosition,
  Vector endPosition,
  double fragmentLength = 50,
}) {
  final Vector lineDelta = endPosition - startPosition;

  final Vector line1 = lineDelta.reduceToLength(fragmentLength);
  final double partsNum = lineDelta.length / line1.length;

  Vector currentPoint;

  for (double q = 0; q <= partsNum; q++) {
    currentPoint = startPosition + line1 * q;

    children.add(Manna(position: currentPoint));
  }

  return currentPoint;
}

Vector mannaCurve({
  List<Actor> children,
  Vector startPosition,
  double startAngle, // [0; 2pi]
  double totalDeltaAngle, // (-pi; +pi]
  double fragmentLength = 50,
  int fragmentsNum,
}) {
  Vector currentPositionVector = Vector.copy(startPosition);
  children.add(Manna(position: startPosition));

  Vector nextFragmentVector =
      Vector(x: fragmentLength, y: 0).rotate(startAngle);

  final double fragmentAngle = totalDeltaAngle / fragmentsNum;

  for (int q = 0; q < fragmentsNum; ++q) {
    nextFragmentVector = nextFragmentVector.rotate(fragmentAngle);

    currentPositionVector += nextFragmentVector;

    children.add(Manna(position: currentPositionVector));
  }

  return currentPositionVector;
}
