import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/foundation.dart';

import 'actor.dart';

class Manna extends Actor {
  Manna({
    @required String name,
    @required double x,
    @required double y,
  }) : super(
          name: 'manna-$name',
          x: x,
          y: y,
          width: 10,
          height: 10,
          image: Assets.instance.mannaImage,
        );
}
