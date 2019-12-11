class Fps {
  final List<double> _averaging = <double>[];

  double calculate(int delta) {
    _averaging.add(delta.toDouble());
    while (_averaging.length > 10) {
      _averaging.removeAt(0);
    }

    final double averageDelay =
        _averaging.reduce((double a, double b) => a + b) / _averaging.length;

    final double fps = (averageDelay == 0) ? 0 : (1000 / averageDelay);

    return fps;
  }
}
