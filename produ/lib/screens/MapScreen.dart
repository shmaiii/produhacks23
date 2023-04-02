import 'package:camera/camera.dart';
import 'Camera.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override 
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  LatLng intialLocation = const LatLng(49.299999, -123.139999);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override 
  void initState() {
    addCustomIcon();
    super.initState();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(40, 60)), 'assets/found-location.png')
      .then(
        (icon) {
          setState(() {
            markerIcon = icon;
          });
        },
      );
  }

  @override 
  Widget build (BuildContext context) {
    return Scaffold(
      
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: intialLocation, 
            zoom: 15,
            ),
          

          markers: {
            Marker(
              markerId: const MarkerId("marker1"),
              position: const LatLng(49.299999, -123.139999),
              draggable: false,
              icon: markerIcon,
            ),

            Marker(
              markerId: const MarkerId("marker2"),
              position: const LatLng(49.299999, -123.169),)
          }

          // Positioned(
          //   top: 16,
          //   left: 16,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       border: Border.all(color: Colors.grey, width: 2,),
          //       borderRadius: BorderRadius.circular(50),
          //     ),
          //     child: IconButton(
          //       icon: Icon(
          //         Icons.camera_alt,
          //         color: Colors.grey),
          //       onPressed: () async {
          //         WidgetsFlutterBinding.ensureInitialized();
          //         await availableCameras().then((value) => Navigator.push(context,
          //             MaterialPageRoute(builder: (_) => CameraScreen(camera: value.first))));
          //       },
              
          //     )
          //   )
          // ),

        // add markers
        ),
      );
  }
}