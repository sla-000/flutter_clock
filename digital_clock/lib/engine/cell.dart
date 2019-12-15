import 'dart:math' as math;

import 'package:digital_clock/engine/tail.dart';
import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'actor.dart';
import 'eye.dart';

const double _kCellCloseDistance = 50;

final Logger _log = Logger('Cell')..level = Level.FINEST;

class Cell extends Actor {
  Cell({
    @required String name,
    @required double x,
    @required double y,
    double scaleX,
    double scaleY,
    double rotation,
  }) : super(
          name: 'cell-$name',
          x: x,
          y: y,
          width: 40,
          height: 40,
          scaleX: scaleX,
          scaleY: scaleY,
          rotation: rotation,
          velocityX: 19,
          velocityY: 17,
          image: Assets.instance.bodyImage,
        ) {
    rotation ??= 0;

    tail = Tail(
      name: name,
      x: -22,
      y: 0,
      scaleX: scaleX,
      scaleY: scaleY,
    );
    children.add(tail);

    eye = Eye(
      name: name,
      x: 8,
      y: 0,
      scaleX: 1.2 / scaleX + 0.8,
      scaleY: 1.2 / scaleY + 0.8,
    );

    children.add(eye);
  }

  Actor eye;

  Actor tail;

  @override
  void update(Actor root, double millis) {
    _move(root, millis);

    _collisions(root);

    super.update(root, millis);
  }

  void _move(Actor root, double millis) {
    rotation += 0.2 * 2 * 3.1415 * (millis / 1000);
  }

  void _collisions(Actor root) {
    _bordersCollisions(root);

    _cellsCollisions(root);
  }

  void _bordersCollisions(Actor root) {
    final double cellRadius = radius();

    if (x < cellRadius) {
      velocityX = -velocityX;
    } else if (x > root.width - cellRadius) {
      velocityX = -velocityX;
    }

    if (y < cellRadius) {
      velocityY = -velocityY;
    } else if (y > root.height - cellRadius) {
      velocityY = -velocityY;
    }
  }

  void _cellsCollisions(Actor root) {
    final List<Cell> collidedCells = root.children
        .whereType<Cell>()
        .where((Cell otherCell) => isCollided(otherCell))
        .where((Cell cell) => cell != this)
        .toList();

    if (collidedCells.isNotEmpty) {
      velocityX = -velocityX;
      velocityY = -velocityY;
    }
  }

  bool isCollided(Cell otherCell) {
    return distance(otherCell) < (radius() + otherCell.radius());
  }

  double distance(Actor other) {
    final double dx = other.x - x;
    final double dy = other.y - y;

    return math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
  }

  double radius() => (width * scaleX + height * scaleY) / 4;
}
