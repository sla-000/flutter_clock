import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Assets {
  Assets._init();

  static Assets instance = Assets._init();

  ui.Image bodyImage;
  ui.Image eyeImage;
  List<ui.Image> tailImages = <ui.Image>[];
  ui.Image mannaImage;

  ValueNotifier<bool> loaded = ValueNotifier<bool>(false);

  static const String _imagesRoot = 'assets/images';

  Future<void> load() async {
    bodyImage = await _getImageFromFile('cell.png');
    eyeImage = await _getImageFromFile('eye.png');

    for (int q = 0; q < 10; ++q) {
      tailImages.add(await _getImageFromFile('tail$q.png'));
    }

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
}
