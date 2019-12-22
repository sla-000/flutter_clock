import 'dart:math' as math;

import 'package:digital_clock/engine/tail.dart';
import 'package:digital_clock/engine/vector.dart';
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
    @required Vector position,
    Vector scale,
    double rotation,
  }) : super(
          name: 'cell-$name',
          position: position,
          size: Vector(x: 40, y: 40),
          scale: scale,
          rotation: rotation,
          velocity: Vector(x: 19, y: 17),
          image: Assets.instance.bodyImage,
        ) {
    rotation ??= 0;

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
    _move(root, millis);

    _collisions(root);

    super.update(root, millis);
  }

  void _move(Actor root, double millis) {
    rotation -= 0.2 * 2 * 3.1415 * (millis / 1000);
  }

  void _collisions(Actor root) {
    _bordersCollisions(root);

    _cellsCollisions(root);
  }

  void _bordersCollisions(Actor root) {
    final double cellRadius = radius();

    if (position.x < cellRadius) {
      velocity.x = -velocity.x;
    } else if (position.x > root.size.x - cellRadius) {
      velocity.x = -velocity.x;
    }

    if (position.y < cellRadius) {
      velocity.y = -velocity.y;
    } else if (position.y > root.size.y - cellRadius) {
      velocity.y = -velocity.y;
    }
  }

  void _cellsCollisions(Actor root) {
    final List<Cell> collidedCells = root.children
        .whereType<Cell>()
        .where((Cell otherCell) => isCollided(otherCell))
        .where((Cell cell) => cell != this)
        .toList();

    if (collidedCells.isNotEmpty) {
      velocity.x = -velocity.x;
      velocity.y = -velocity.y;
    }
  }

  bool isCollided(Cell otherCell) {
    return distance(otherCell) < (radius() + otherCell.radius());
  }

  double distance(Actor other) {
    final double dx = other.position.x - position.x;
    final double dy = other.position.y - position.y;

    return math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
  }

  double radius() => (size.x * scale.x + size.y * scale.y) / 4;
}
