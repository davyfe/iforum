import 'package:google_maps_flutter/google_maps_flutter.dart';

class Locais {
  static const LatLng campusArapiraca = LatLng(-9.745411, -36.631326);
  // aproximada: confira no Google Maps antes de usar
  static const LatLng campusPenedo = LatLng(-10.2897, -36.5838);

  /// Eventos só guardam o nome do local em texto.
  static LatLng buscar(String local) {
    if (local.toLowerCase().contains('penedo')) return campusPenedo;
    return campusArapiraca;
  }
}