library canvas_to_image;

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class CanvasImageSaver {
  ui.Canvas canvas;
  ui.PictureRecorder _pictureRecorder;

  Canvas startPaint() {
    _pictureRecorder = ui.PictureRecorder();
    canvas = Canvas(_pictureRecorder);

    return canvas;
  }

  Future<ByteData> createImage(int width, int height) async {
    var pic = _pictureRecorder.endRecording();
    ui.Image img = await pic.toImage(width, height);
    var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData;
  }

  Future<void> saveFile(String file, int width, int height) async {
    final imageFile = File(file);
    await imageFile
        .writeAsBytes((await createImage(width, height)).buffer.asUint8List());
  }
}
