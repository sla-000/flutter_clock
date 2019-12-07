import 'package:flutter/painting.dart';

class Config {
  Config._init();

  static Config instance = Config._init();

  FilterQuality filterQuality = FilterQuality.high;
}
