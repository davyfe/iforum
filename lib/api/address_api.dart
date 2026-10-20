import 'package:dio/dio.dart';
import 'package:iforum/domain/address.dart';

class AddressApi {
  final dio = Dio();
  String baseUrl = 'https://viacep.com.br';

  Future<Address?> findByCep(String cep) async {
    final response = await dio.get('$baseUrl/ws/$cep/json/');

    if (response.statusCode == 200 && response.data['erro'] == null) {
      return Address.fromJson(response.data);
    }
    return null;
  }
}