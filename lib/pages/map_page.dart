import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/widget/build_text.dart';
import '/cores.dart';

class MapPage extends StatefulWidget {
  final LatLng location;
  final String titulo;
  final String descricao;
  final Set<Marker>? markers;

  const MapPage({
    super.key,
    required this.location,
    this.titulo = 'Mapa',
    this.descricao = '',
    this.markers,
  });

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  Set<Marker> get _markers =>
      widget.markers ??
          {
            Marker(
              markerId: const MarkerId('local'),
              position: widget.location,
              infoWindow: InfoWindow(
                title: widget.titulo,
                snippet: widget.descricao.isEmpty ? null : widget.descricao,
              ),
            ),
          };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Cores.verde,
        title: BuildText(
          widget.titulo,
          bold: true,
          color: Colors.white,
          size: 20,
        ),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: widget.location, zoom: 16),
        markers: _markers,
        onMapCreated: (GoogleMapController c) => _controller.complete(c),
      ),
    );
  }
}