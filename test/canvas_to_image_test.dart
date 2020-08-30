import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:canvas_to_image/canvas_to_image.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    // Create a temporary directory.
    final directory = await Directory.systemTemp.createTemp();
    // Mock out the MethodChannel for the path_provider plugin.
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      // If you're getting the apps documents directory, return the path to the
      // temp directory on the test environment instead.
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return directory.path;
      }
      return null;
    });
  });

  test('Should create the image file under temp foler', () async {
    final saver = CanvasImageSaver();
    final canvas = saver.startPaint();
    final paint = Paint();
    paint.color = Colors.black;
    canvas.drawLine(Offset(0, 0), Offset(50, 50), paint);

    final data = await saver.createImage(100, 100);
    final directory = await getApplicationDocumentsDirectory();
    final imageFile = File('${directory.path}/test.png');
    await imageFile.writeAsBytes(data.buffer.asUint8List());
    assert(imageFile.existsSync());
    assert(imageFile.lengthSync() > 0, true);
  });
}
