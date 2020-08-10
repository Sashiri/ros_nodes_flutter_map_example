import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ros_nodes/messages/geometry_msgs/Twist.dart';
import 'package:ros_nodes/messages/nav_msgs/OccupancyGrid.dart';
import 'package:ros_nodes/messages/sensor_msgs/CompressedImage.dart';
import 'package:ros_nodes/ros_nodes.dart';
import 'package:ros_nodes_dart_test/OccupancyGridExtension.dart';

class RosNotifier extends ChangeNotifier {
  ui.Image _mapImage;
  ui.Image get mapImage => _mapImage;

  Uint8List _visionImage;
  Uint8List get visionImage => _visionImage;

  GeometryMsgsTwist _veliocity;
  GeometryMsgsTwist get veliocity => _veliocity;

  bool _visionAvailable = false;
  bool get visionAvailable => _visionAvailable;

  bool _veliocityAvailable = false;
  bool get veliocityAvailable => _veliocityAvailable;

  bool _mapAvailable = false;
  bool get mapAvailable => _mapAvailable;

  RosNotifier(RosConfig _config) {
    _client = RosClient(_config);
    init();
  }

  void init() async {
    print('initializing ros subscribers');

    await Future.wait([
      _subscribeToCamera(),
      _subscribeToMap(),
      _subscribeToVeliocity(),
    ]);
  }

  @override
  void dispose() {
    _closeSubscribtions();
    super.dispose();
  }

  RosClient _client;

  final _visionTopic =
      RosTopic('camera/rgb/image_raw/compressed', SensorMsgsCompressedImage());

  final _mapTopic = RosTopic('map', NavMsgsOccupancyGrid());

  final _veliocityTopic = RosTopic('cmd_vel', GeometryMsgsTwist());

  void _mapUpdate(ui.Image val) {
    _mapImage = val;
    notifyListeners();
  }

  Future<void> _subscribeToMap() async {
    var subscriber = await _client.subscribe(_mapTopic);
    subscriber.onValueUpdate.listen((msg) {
      ui.decodeImageFromPixels(
        msg.toRGBA(),
        msg.info.width,
        msg.info.width,
        ui.PixelFormat.rgba8888,
        _mapUpdate,
      );
    });

    _mapAvailable = true;
    notifyListeners();
  }

  Future<void> _subscribeToCamera() async {
    var subscriber = await _client.subscribe(_visionTopic);
    subscriber.onValueUpdate.listen((msg) {
      _visionImage = msg.data;
      notifyListeners();
    });

    _visionAvailable = true;
    notifyListeners();
  }

  Future<void> _subscribeToVeliocity() async {
    var subscriber = await _client.subscribe(_veliocityTopic);
    subscriber.onValueUpdate.listen((msg) {
      _veliocity = msg;
      notifyListeners();
    });

    _veliocityAvailable = true;
    notifyListeners();
  }

  Future<void> _closeSubscribtions() async {
    if (visionAvailable) {
      await _client.unsubscribe(_visionTopic);
      _visionAvailable = false;
    }
    if (mapAvailable) {
      await _client.unsubscribe(_mapTopic);
      _mapAvailable = false;
    }
    if (veliocityAvailable) {
      await _client.unsubscribe(_veliocityTopic);
      _veliocityAvailable = false;
    }
    notifyListeners();
    await _client.close();
  }
}
