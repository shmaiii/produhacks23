import '../main.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';
import 'DisplayPictureScreen.dart';
import 'VideoPlaying.dart';

// class CameraPage extends StatelessWidget {
//   const CameraPage({Key? key}) : super(key:key);

//   @override
//   Widget build(BuildContext context){
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CameraScreen(),
//     );
//   }
// }

class CameraScreen extends StatefulWidget {
 
  CameraScreen({Key? key, required this.camera, required this.updateVisited}): super(key: key);
  final Function(bool) updateVisited;
  final CameraDescription camera;
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange,),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Container (
        width: double.infinity,
        height: double.infinity,
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

  


