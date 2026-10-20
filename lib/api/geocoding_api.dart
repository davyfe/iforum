import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodingApi {
  final dio = Dio();
  String baseUrl = 'https://nominatim.openstreetmap.org';

  Future<LatLng?> buscarCoordenadas(String consulta) async {
    try {
      final response = await dio.get(
        '$baseUrl/search',
        queryParameters: {'q': consulta, 'format': 'json', 'limit': 1},
        options: Options(headers: {'User-Agent': 'iforum-app'}),
      );

      final dados = response.data;
      if (response.statusCode == 200 && dados is List && dados.isNotEmpty) {
        return LatLng(
          double.parse(dados[0]['lat']),
          double.parse(dados[0]['lon']),
        );
      }
    } catch (_) {}
    return null;
  }
}