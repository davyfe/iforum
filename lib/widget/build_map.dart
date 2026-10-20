import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/widget/build_text.dart';
import '/cores.dart';

class MapPage extends StatelessWidget {
  final String titulo;
  final String descricao;
  final LatLng posicao;

  const MapPage({
    super.key,
    this.titulo = 'Campus Arapiraca',
    this.descricao = 'IFAL - Campus Arapiraca',
    this.posicao = const LatLng(-9.745653, -36.631347),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Cores.verde,
        title: BuildText(titulo, bold: true, color: Colors.white, size: 20),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: posicao, zoom: 16),
        markers: {
          Marker(
            markerId: const MarkerId('local'),
            position: posicao,
            infoWindow: InfoWindow(title: descricao),
          ),
        },
        zoomControlsEnabled: true,
        myLocationButtonEnabled: false,
      ),
    );
  }
}