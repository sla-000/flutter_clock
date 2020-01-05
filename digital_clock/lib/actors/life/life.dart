import 'package:digital_clock/actors/cell/cell.dart';
import 'package:digital_clock/actors/scene/digits/manna.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/math.dart';
import 'package:digital_clock/engine/vector.dart';

const double kMaxAge = 15000.0;
const double kGrandfatherAge = kMaxAge - 2000.0;
const double kMaturityAge = 2000.0;
const double kNextBirth = 500.0;

const double kTooCloseToLiveDistance = 100;
const int kTooManyNeighbors = 3;

const double kManyMannaDistance = 80;
const double kLowMannaDistance = 200;

const double kMinGrowScale = 1.0;
const double kMaxGrowScale = 3.0;

class Life {
  double _ageMillis;
  double _matureMillis;
  double _nextBirth = kMaturityAge;

  void live(Actor root, Cell cell, double millis) {
    _ageMillis ??= 0;
    _matureMillis ??= 0;

    final List<Cell> otherCells = root.children
        .whereType<Cell>()
        .where((Cell otherCell) => otherCell != cell)
        .toList(growable: false);

    final List<Manna> mannas =
        root.children.whereType<Manna>().toList(growable: false);

    _eat(otherCells, mannas, cell, millis);

    _updateLook(cell);

    _breed(root, cell);

    _rip(root, cell);

    _ageMillis += millis;
  }

  void _eat(
      List<Cell> otherCells, List<Manna> manna, Cell cell, double millis) {
    final bool haveEnoughManna = manna
        .where((Manna manna) => cell.distance(manna) < kManyMannaDistance)
        .isNotEmpty;

    final bool notEnoughManna = manna
        .where((Manna manna) => cell.distance(manna) < kLowMannaDistance)
        .isEmpty;

    final int neighbors = otherCells
        .where((Cell otherCell) =>
            cell.distance(otherCell) < kTooCloseToLiveDistance)
        .length;

    final bool haveEnoughRoom = neighbors < kTooManyNeighbors;

    _matureFaster(haveEnoughManna, haveEnoughRoom, millis);

    _oldFaster(neighbors, millis);

    _starve(notEnoughManna, millis);
  }

  void _matureFaster(bool haveEnoughManna, bool haveEnoughRoom, double millis) {
    if (haveEnoughManna && haveEnoughRoom) {
      _matureMillis += millis;
    }
  }

  void _oldFaster(int neighbors, double millis) {
    if (neighbors > kTooManyNeighbors) {
      _ageMillis += (neighbors - kTooManyNeighbors) * millis;
    }
  }

  void _starve(bool notEnoughManna, double millis) {
    if (notEnoughManna) {
      _ageMillis += millis;
    }
  }

  void _updateLook(Cell cell) {
    _fade(cell);

    _size(cell);
  }

  void _size(Cell cell) {
    final double scale =
        normalize(_matureMillis, 0, kMaxAge) * kMaxGrowScale + kMinGrowScale;

    cell.scale.x = scale;
    cell.scale.y = scale;
  }

  void _fade(Cell cell) {
    if (_ageMillis > kGrandfatherAge) {
      cell.fade = normalize(_ageMillis, kGrandfatherAge, kMaxAge);
    }
  }

  void _breed(Actor root, Cell cell) {
    if (_matureMillis > _nextBirth) {
      _nextBirth = _matureMillis + kNextBirth;

      root.children.insert(
        0,
        Cell(
          position: Vector.copy(cell.position),
          scale: Vector.both(kMinGrowScale),
          angle: oppositeAngle(cell.angle),
          velocityAngle: oppositeAngle(cell.velocityAngle),
        ),
      );
    }
  }

  void _rip(Actor root, Cell cell) {
    if (_ageMillis > kMaxAge) {
      root.children.remove(cell);
    }
  }
}
