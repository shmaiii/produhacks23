import 'dart:async';

import 'package:flutter/material.dart';
import 'package:produ/screens/Camera.dart';
import 'package:camera/camera.dart';
import 'screens/Camera.dart';
import 'screens/MapScreen.dart';
import 'screens/SplashScreen.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  //const MyApp({super.key});

  @override 
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  bool splashing = true;

  @override 
  void initState() {
    super.initState();
    Timer(Duration(seconds: 10), () {
      setState(() {
        splashing = false;
      });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: splashing? SplashPage() : MapScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2,),
              borderRadius: BorderRadius.circular(50),
            ),
          child: IconButton(
            icon: Icon(
              Icons.camera_alt,
              color: Colors.grey),
            onPressed: () async {
              WidgetsFlutterBinding.ensureInitialized();
              await availableCameras().then((value) => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CameraScreen(camera: value.first))));
            },
          
        ))),
      ),
    );
  }
}