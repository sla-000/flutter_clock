import 'dart:math' as math;

import 'package:digital_clock/actors/cell/eye.dart';
import 'package:digital_clock/actors/cell/tail.dart';
import 'package:digital_clock/actors/manna.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/math.dart';
import 'package:digital_clock/engine/vector.dart';
import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger('Cell')..level = Level.FINEST;

class Cell extends Actor {
  Cell({
    @required String name,
    @required Vector position,
    Vector scale,
    double angle,
    double velocity,
    double velocityAngle,
  }) : super(
          name: 'cell-$name',
          position: position,
          size: Vector(x: 40, y: 40),
          scale: scale,
          angle: angle,
          velocityModule: velocity ?? 100,
          velocityAngle: velocityAngle ?? 0.5,
          image: Assets.instance.bodyImage,
        ) {
    angle ??= 0;

    tail = Tail(
      name: name,
      position: Vector(x: -22, y: 0),
      scale: scale,
    );
    children.add(tail);

    eye = Eye(
      name: name,
      position: Vector(x: 8, y: 0),
      scale: Vector(x: 1.2 / scale.x + 0.8, y: 1.2 / scale.y + 0.8),
    );

    children.add(eye);
  }

  Actor eye;

  Actor tail;

  @override
  void update(Actor root, double millis) {
    _approachManna(root);

    _collisions(root);

    super.update(root, millis);
  }

  void _approachManna(Actor root) {
    final Vector mannaVector = _findClosestManna(root);

    velocityAngle +=
        getAngleDelta(velocityAngle, getVectorAngle(mannaVector)) / 5;
  }

  Vector _findClosestManna(Actor root) {
    double minDistance = double.infinity;
    Vector mannaVector;

    root.children.whereType<Manna>().forEach((Manna manna) {
      final double calculatedDistance = distance(manna);
      if (calculatedDistance < minDistance) {
        minDistance = calculatedDistance;
        mannaVector = manna.deltaVector(this);
      }
    });

    return mannaVector;
  }

  void _collisions(Actor root) {
    _bordersCollisions(root);

    _cellsCollisions(root);
  }

  void _bordersCollisions(Actor root) {
    final double cellRadius = radius();

    if (position.x < cellRadius &&
        getDirection(velocityAngle).contains(Direction.west)) {
      velocityAngle = getNextAngle(math.pi * 0 / 2, velocityAngle);
    } else if (position.x > root.size.x - cellRadius &&
        getDirection(velocityAngle).contains(Direction.east)) {
      velocityAngle = getNextAngle(math.pi * 2 / 2, velocityAngle);
    }

    if (position.y < cellRadius &&
        getDirection(velocityAngle).contains(Direction.north)) {
      velocityAngle = getNextAngle(math.pi * 1 / 2, velocityAngle);
    } else if (position.y > root.size.y - cellRadius &&
        getDirection(velocityAngle).contains(Direction.south)) {
      velocityAngle = getNextAngle(math.pi * 3 / 2, velocityAngle);
    }
  }

  void _cellsCollisions(Actor root) {
    final List<Cell> collidedCells = root.children
        .whereType<Cell>()
        .where((Cell otherCell) => isCollided(otherCell))
        .where((Cell cell) => cell != this)
        .toList();

    if (collidedCells.isNotEmpty) {
      velocityAngle = getCollideResultVectorAngle(collidedCells[0]);
    }
  }

  bool isCollided(Cell otherCell) {
    return distance(otherCell) < (radius() + otherCell.radius());
  }

  double getCollideResultVectorAngle(Cell cell) {
    return getVectorAngle(deltaVector(cell));
  }
}
