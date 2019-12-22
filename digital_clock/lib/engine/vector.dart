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

  double x;
  double y;

  double get length => math.sqrt(x * x + y * y);

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
