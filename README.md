# ros_nodes_dart_test

Example of how can you connect [ros_nodes] and [flutter].

## Getting Started
[ros_nodes]: https://github.com/Sashiri/ros_nodes


To make it work, please change your configuration in lib/main.dart
```dart
home: MyHomePage(
    title: 'Flutter vision',
    config: RosConfig(
        'flutter_demo',
        'http://ROS_MASTER_URI:11311/',
        "ROS_HOSTNAME-IP",
        12345,
    ),
),
```

Topic subscribtion is in lib/RosNotifier.dart

| Resource   |      Topic      |
|----------|:-------------:|
| camera view |  camera/rgb/image_raw/compressed |
| scaner map |    map   |
| speed | cmd_vel |