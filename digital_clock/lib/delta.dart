class Delta {
  int _lastMillis;

  int calculate(int millis) {
    _lastMillis ??= millis;
    final int delta = millis - _lastMillis;
    _lastMillis = millis;

    return delta;
  }
}
