import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  MapScreen();

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocation;

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      setState(() {
        currentLocation = locData;
      });
    } catch (error) {
      return;
    }
  }

  late CameraPosition _currentLoc = CameraPosition(
      target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      zoom: 17);

  Future<void> _goToTheCurrentLoc() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentLoc));
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 17,
              ),
              // markers: (_pickedLocation == null && widget.isSelecting)
              //     ? {}
              //     : {
              //         Marker(
              //             markerId: MarkerId('m1'),
              //             position: _pickedLocation ??
              //                 LatLng(currentLocation!.latitude!,
              //                     currentLocation!.longitude!))
              //       },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToTheCurrentLoc,
        tooltip: 'refresh',
        child: new Icon(Icons.refresh),
      ),
    );
  }
}
