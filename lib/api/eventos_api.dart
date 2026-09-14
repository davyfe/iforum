import 'package:dio/dio.dart';
import '/domain/evento.dart';

class EventosApi {
  final dio = Dio();

  Future<List<Evento>> listarEventos() async {
    final response = await dio.get(
      'https://my-json-server.typicode.com/davyfe/fake_api/evento',
    );

    List<Evento> lista = [];

    if (response.statusCode == 200) {
      for (var json in response.data) {
        Evento evento = Evento.fromJson(json);
        lista.add(evento);
      }
    }
    return lista;
  }
}
