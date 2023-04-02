import '../main.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';
import 'DisplayPictureScreen.dart';
import 'VideoPlaying.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import '../streaming/models.dart';


class CameraStreamingScreen extends StatefulWidget {
 
  CameraStreamingScreen({Key? key, required this.camera, required this.updateVisited}): super(key: key);
  final Function(bool) updateVisited;
  final CameraDescription camera;
  @override
  State<CameraStreamingScreen> createState() => _CameraStreamingScreenState();
}

class _CameraStreamingScreenState extends State<CameraStreamingScreen> {
  late CameraImage cameraImage;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<dynamic>? recognitionsList = [];

  @override
  void initState() {
    super.initState();
    loadModel();
    
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize().then((value) {
      if (!mounted) return;
      setState(() {
        _controller.startImageStream((image) {
          cameraImage = image;
          runModel();
        });
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.stopImageStream();
    Tflite.close();
    _controller.dispose();
    super.dispose();
  }

  Future loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/ssd_mobilenet.txt");
  }

  runModel() async {
    recognitionsList = await Tflite.detectObjectOnFrame(
      bytesList: cameraImage.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,);

      setState(() {
        cameraImage;
      });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
  if (recognitionsList == null) return [];
  else {
  double factorX = screen.width;
  double factorY = screen.height;

  Color colorPick = Colors.pink;

  return recognitionsList!.map((result) {
    return Positioned(
      left: result["rect"]["x"] * factorX,
      top: result["rect"]["y"] * factorY,
      width: result["rect"]["w"] * factorX,
      height: result["rect"]["h"] * factorY,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(color: Colors.pink, width: 2.0),
        ),
        child: Text(
          "${result['detectedClass']} ${(result['confidenceInClass'] * 100).toStringAsFixed(0)}%",
          style: TextStyle(
            background: Paint()..color = colorPick,
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }).toList();
}}

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    List<Widget> list = [];

    list.add(
      Positioned(
        top: 0,
        left: 0,
        width: size.width,
        height: size.height - 100,
        child: Container(
          height: size.height - 100,
          child: (!_controller.value.isInitialized)
          ? new Container()
          : AspectRatio(aspectRatio: _controller.value.aspectRatio,
          child: CameraPreview(_controller),
          ),
          )));

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange,),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Container (
        // width: double.infinity,
        // height: double.infinity,
        
        child: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter, 
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
        
        onPressed: () async { 
          try {
            
            await _initializeControllerFuture;

            final image = await _controller.takePicture();

            if (!mounted) return;
            widget.updateVisited (true);
            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        
      ),)
    );
  }
}



