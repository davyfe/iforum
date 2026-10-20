import 'package:dio/dio.dart';

class AddressApi {
  final dio = Dio();
  String baseUrl = 'https://viacep.com.br';

  Future<Map<String, dynamic>?> findByCep(String cep) async {
    try {
      final response = await dio.get('$baseUrl/ws/$cep/json/');
      if (response.statusCode == 200 && response.data['erro'] != true) {
        return Map<String, dynamic>.from(response.data);
      }
    } catch (_) {}
    return null;
  }
}