import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MaterialApp(home: CameraApp()));
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: TakePictureFAB(
              onPressed: () {
                controller.takePicture().then((imageXFile) async {});
              },
            ),
          ),
        ),
      ],
    );
  }
}

class TakePictureFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const TakePictureFAB({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color =
        onPressed != null ? Theme.of(context).accentColor : Colors.grey;
    return FloatingActionButton(
      backgroundColor: Colors.transparent,
      shape: CircleBorder(
        side: BorderSide(
          width: 4,
          color: color,
        ),
      ),
      elevation: 0,
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
