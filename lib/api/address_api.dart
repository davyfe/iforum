import 'package:dio/dio.dart';

class AddressApi {
  final dio = Dio();
  String baseUrl = 'https://viacep.com.br';

    final response = await dio.get('$baseUrl/ws/$cep/json/');
    }
    return null;
  }
}