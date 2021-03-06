import 'dart:math' as math;

import 'package:digital_clock/actors/cell/body.dart';
import 'package:digital_clock/actors/cell/eye.dart';
import 'package:digital_clock/actors/cell/tail.dart';
import 'package:digital_clock/actors/life/life.dart';
import 'package:digital_clock/actors/scene/digits/manna.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/math.dart';
import 'package:digital_clock/engine/vector.dart';
import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger('Cell')..level = Level.FINEST;

class Cell extends Actor {
  Cell({
    @required Vector position,
    Vector scale,
    double angle,
    double velocity,
    double velocityAngle,
  }) : super(
          position: position,
          size: Vector(x: 40, y: 40),
          scale: scale ?? Vector.both(1.0),
          angle: angle,
          velocityModule: velocity ?? 100,
          velocityAngle: velocityAngle ?? 0.5,
          image: Assets.instance.bodyImage,
        ) {
    angle ??= 0;

    tail = Tail(
      position: Vector(x: -22, y: 0),
      scale: this.scale,
    );
    children.add(tail);

    body = Body();
    children.add(body);

    eye = Eye(
      position: Vector(x: 8, y: 0),
      scale: Vector(x: 1.2 / this.scale.x + 0.8, y: 1.2 / this.scale.y + 0.8),
    );
    children.add(eye);

    life = Life();
  }

  Body body;

  Eye eye;

  Tail tail;

  Life life;

  /// 1-total fade out, 0-normal
  double tired = 0;

  @override
  void update(Actor root, double millis) {
    life.live(root, this, millis);

    body.setTired(tired);
    eye.setTired(tired);

    _approachManna(root);

    _processEating(root);

    _collisions(root);

    super.update(root, millis);
  }

  void _processEating(Actor root) {} // todo _processEating

  void _approachManna(Actor root) {
    final Vector mannaVector = _findClosestManna(root);

    final Vector cellVector = _findClosestCells(root);

    final Vector finalVector = getVectorsSum(mannaVector, -cellVector);

    velocityAngle +=
        getAngleDelta(velocityAngle, getVectorAngle(finalVector)) / 10;
  }

  Vector _findClosestManna(Actor root) {
    double minDistance = double.infinity;
    Vector mannaVector = Vector.zero();

    root.children.whereType<Manna>().forEach((Manna manna) {
      final double calculatedDistance = distance(manna);
      if (calculatedDistance < minDistance) {
        minDistance = calculatedDistance;

        mannaVector = manna.deltaVector(this) *
            _getMannaDistanceKoeff(calculatedDistance);
      }
    });

    return mannaVector;
  }

  double _getMannaDistanceKoeff(double distance) {
    if (distance > 1000) {
      return 0;
    }

    return -distance / 1000 + 1;
  }

  Vector _findClosestCells(Actor root) {
    double minDistance = double.infinity;
    Vector cellVector = Vector.zero();

    root.children.whereType<Cell>().forEach((Cell cell) {
      final double calculatedDistance = distance(cell);
      if (calculatedDistance < minDistance) {
        minDistance = calculatedDistance;

        cellVector =
            cell.deltaVector(this) * _getCellDistanceKoeff(calculatedDistance);
      }
    });

    return cellVector;
  }

  double _getCellDistanceKoeff(double distance) {
    if (distance > 200) {
      return 0;
    }

    return -distance / 200 + 1;
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
