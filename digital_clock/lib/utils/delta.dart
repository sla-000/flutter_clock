class Delta {
  int _lastMillis;

  int calculate(
    int millis, {
    bool ignore = false,
  }) {
    _lastMillis ??= millis;
    final int delta = millis - _lastMillis;
    _lastMillis = millis;

    return ignore ? 0 : delta;
  }
}
