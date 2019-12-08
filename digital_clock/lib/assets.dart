import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

ui.Image bodyImage;
ui.Image eyeImage;
ui.Image tailImage;
ui.Image mannaImage;

const String _imagesRoot = 'assets/images';

ValueNotifier<bool> loaded = ValueNotifier<bool>(false);

Future<void> load() async {
  bodyImage = await _getImageFromFile('cell.png');
  eyeImage = await _getImageFromFile('eye.png');
  tailImage = await _getImageFromFile('tail.png');
  mannaImage = await _getImageFromFile('manna.png');

  loaded.value = true;
}

Future<ui.Image> _getImageFromFile(String imageName) async {
  final ByteData cellImageFile =
      await rootBundle.load('$_imagesRoot/$imageName');

  final ui.Codec codec =
      await ui.instantiateImageCodec(Uint8List.view(cellImageFile.buffer));

  final ui.FrameInfo frame = await codec.getNextFrame();

  return frame.image;
}
