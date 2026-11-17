import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const LatLng _local = LatLng(-9.745474606180297, -36.63133713239652);

  static const CameraPosition cameraPosition = CameraPosition(
    target: _local,
    zoom: 14.4746,
  );

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('local'),
      position: _local,
      infoWindow: InfoWindow(title: 'IFAL, Arapiraca', snippet: 'Escola'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: _markers,
        mapType: MapType.normal,
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
