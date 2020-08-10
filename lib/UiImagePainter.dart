import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

class UiImagePainter extends CustomPainter {
  ui.Image _image;
  get image => _image;

  UiImagePainter(ui.Image image) {
    _image = image;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(1, -1);
    canvas.translate(0, -_image.height.toDouble());
    canvas.drawImage(_image, Offset.zero, Paint());
    canvas.restore();
  }

  @override
  bool shouldRepaint(UiImagePainter oldDelegate) =>
      oldDelegate.image.hashCode != image.hashCode;
}
