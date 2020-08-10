import 'dart:io';
import 'dart:typed_data';

import 'package:ros_nodes/messages/nav_msgs/OccupancyGrid.dart';

extension GridImageConverter on NavMsgsOccupancyGrid {
  Uint8List toRGBA() {
    var buffor = BytesBuilder();
    for (var value in data) {
      switch (value) {
        case -1:
          buffor.add([77, 77, 77, 255]);
          break;
        default:
          var grayscale = (((100 - value) / 100.0) * 255).round().toUnsigned(8);
          var r = grayscale;
          var b = grayscale;
          var g = grayscale;
          const a = 255;
          buffor.add([r, g, b, a]);
      }
    }
    return buffor.takeBytes();
  }
}
