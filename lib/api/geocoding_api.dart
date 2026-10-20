import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodingApi {
  final dio = Dio();

  Future<LatLng?> buscarCoordenadas(String endereco) async {
    final response = await dio.get(
      'https://nominatim.openstreetmap.org/search',
      queryParameters: {'q': endereco, 'format': 'json', 'limit': 1},
      options: Options(headers: {'User-Agent': 'iforum-app'}),
    );

    final lista = response.data as List;
    if (lista.isEmpty) return null;

    return LatLng(
      double.parse(lista.first['lat']),
      double.parse(lista.first['lon']),
    );
  }
}