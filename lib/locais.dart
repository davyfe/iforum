import 'package:google_maps_flutter/google_maps_flutter.dart';

class Locais {
  static const LatLng campusArapiraca = LatLng(-9.745411, -36.631326);
  static const LatLng campusPenedo = LatLng(-10.2897, -36.5838);
  static const LatLng campusNatal = LatLng(-5.804792955700983, -35.20504586516969);

  /// Eventos só guardam o nome do local em texto.
  static LatLng buscar(String local) {
    if (local.toLowerCase().contains('penedo')) return campusPenedo;
    if (local.toLowerCase().contains('natal')) return campusNatal;
    return campusArapiraca;
  }
}