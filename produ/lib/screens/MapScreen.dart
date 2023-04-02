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

  void _showDialog(BuildContext context) {
    showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text("The Seven Sisters"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("The Seven Sisters trees were some of the tallest trees in the world. They resided in a small area in the middle of Stanley Park. When people stood among them they felt like they were in a cathedral. They were so popular that 'Cathedral Trail' was cut to help people get to them quicker. Eventually, because so many people walked on their roots they became dangerous and were cut down in the 1950s. All that remains of them is their stumps. Now, new trees have been planted in the same area, who will one day grow to be as tall as the previous seven sisters."),
            SizedBox(height: 16),
            Text("However, the seven sisters surrounds a Squamish legend: a stone that has no moss or lichen would dare grow on it, and splashed with jet-black spots that have eaten into the surface like an acid. The stone contains a  a “lure:” an evil spirit that has been trapped as a stone that compels people to circle around it, and then kills them. Once people come within the \"aura\" of the lure it is a human impossibility to leave it, hence being called a “lure”."),
          ],
        ),
      ),
    );
  },
);


  }

  void _hideDialog() {
    Navigator.of(context).pop();
  } 

  @override 
  Widget build (BuildContext context) {
    return Scaffold(
      
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: intialLocation, 
            zoom: 15,
            ),
          
          // add markers
          markers: {
            Marker(
              markerId: const MarkerId("marker1"),
              position: const LatLng(49.299999, -123.139999),
              draggable: false,
              icon: markerIcon,
              onTap: () {
                _showDialog(context);
              }
            ),

            Marker(
              markerId: const MarkerId("marker2"),
              position: const LatLng(49.299999, -123.169),)
          }

        ),
      );
  }
}