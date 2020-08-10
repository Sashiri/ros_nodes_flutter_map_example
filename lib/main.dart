import 'package:flutter/material.dart';
import 'package:ros_nodes/ros_nodes.dart';
import 'package:ros_nodes_dart_test/RosNotifier.dart';
import 'package:ros_nodes_dart_test/UiImagePainter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Flutter vision',
        config: RosConfig(
          'flutter_demo',
          'http://ROS_MASTER_URI:11311/',
          "ROS_HOSTNAME-IP",
          12345,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.title, @required this.config})
      : super(key: key);

  final String title;
  final RosConfig config;

  @override
  _MyHomePageState createState() => _MyHomePageState(config);
}

class _MyHomePageState extends State<MyHomePage> {
  RosNotifier vision;

  _MyHomePageState(RosConfig config) : super() {
    vision = RosNotifier(config);
    vision.addListener(_refresh);
  }

  @override
  void dispose() {
    vision.dispose();
    vision = null;
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FittedBox(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  vision.visionAvailable
                      ? Image.memory(vision.visionImage, gaplessPlayback: true)
                      : CircularProgressIndicator(),
                  vision.mapAvailable
                      ? FittedBox(
                          child: SizedBox(
                            width: vision.mapImage.width.toDouble(),
                            height: vision.mapImage.height.toDouble(),
                            child: CustomPaint(
                                painter: UiImagePainter(vision.mapImage)),
                          ),
                        )
                      : CircularProgressIndicator(),
                ],
              ),
              Text(vision.veliocityAvailable
                  ? vision.veliocity.linear.x.toString()
                  : "No veliocity available"),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh view',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
