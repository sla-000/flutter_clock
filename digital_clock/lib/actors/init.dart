import 'package:digital_clock/actors/cell/cell.dart';
import 'package:digital_clock/actors/cell/eye.dart';
import 'package:digital_clock/actors/cell/tail.dart';
import 'package:digital_clock/actors/scene/digits/manna.dart';
import 'package:digital_clock/actors/scene/scene.dart';
import 'package:digital_clock/engine/actor.dart';

void initBeforeDrawActors() {
  Visible.instance.add<Scene>(drawScene);
  Visible.instance.add<Cell>(drawCell);
  Visible.instance.add<Tail>(drawTail);
  Visible.instance.add<Eye>(drawEye);
  Visible.instance.add<Manna>(drawManna);
}
