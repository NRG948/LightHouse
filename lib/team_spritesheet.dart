import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class TeamSpritesheet {
  static int spriteWidth = 40;
  static int spriteHeight = 40;
  static ui.Image? spritesheet;
  static void loadSpritesheet() async {
    final ByteData data = await rootBundle.load("assets/images/spritesheet.png");
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frame = await codec.getNextFrame();
    spritesheet = frame.image;

  }
  static Future<Uint8List> getTeamPicture(int teamNumber) async {
    while (spritesheet == null) {
      await Future.delayed(Duration(milliseconds: 200));
    }
    int row = (teamNumber ~/ 104);
    int column = (teamNumber % 104) - 1;
    ui.PictureRecorder recorder = ui.PictureRecorder();
    ui.Canvas canvas = ui.Canvas(recorder);
    ui.Paint paint = ui.Paint();

    // Calculate the position of the sprite in the sheet
    double x = column * spriteWidth.toDouble();
    double y = row * spriteHeight.toDouble();
    Rect srcRect = Rect.fromLTWH(x, y, spriteWidth.toDouble(), spriteHeight.toDouble());
    Rect dstRect = Rect.fromLTWH(0,0, spriteWidth.toDouble(), spriteHeight.toDouble());
    // Draw only the desired sprite onto a new canvas
    canvas.drawImageRect(spritesheet!, srcRect, dstRect, paint);
    // Convert the drawing to an image
    ui.Image image = await recorder.endRecording().toImage(spriteWidth, spriteHeight);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}