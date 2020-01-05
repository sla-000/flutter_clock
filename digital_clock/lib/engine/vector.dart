import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

class Vector {
  Vector({
    @required this.x,
    @required this.y,
  });

  Vector.zero() : this(x: 0, y: 0);

  Vector.both(double d) : this(x: d, y: d);

  Vector.one() : this(x: 1, y: 1);

  Vector.copy(Vector v) : this(x: v.x, y: v.y);

  double x;
  double y;

  double get length => math.sqrt(x * x + y * y);

  Vector reduceToLength(double value) {
    final double normalizer = length / value;
    return this / normalizer;
  }

  Vector operator *(double value) => Vector(x: x * value, y: y * value);
  Vector operator /(double value) => Vector(x: x / value, y: y / value);

  Vector operator -(Vector value) => Vector(x: x - value.x, y: y - value.y);

  Vector operator +(Vector value) => Vector(x: x + value.x, y: y + value.y);

  Vector operator -() => Vector(x: -x, y: -y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vector &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() {
    return 'Vector{x: $x, y: $y}';
  }
}
