import 'package:dio/dio.dart';
import '/domain/evento.dart';

class EventosApi {
  final dio = Dio();

  Future<List<Evento>> listarEventos() async {
    final response = await dio.get(
      'https://my-json-server.typicode.com/davyfe/fake_api/evento',
    );
    return (response.data as List)
        .map((json) => Evento.fromJson(json))
        .toList();
  }
}
