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

  Future<bool> atualizarFavorito(int id, bool favorito) async {
    try {
      final response = await dio.patch(
        'https://my-json-server.typicode.com/davyfe/fake_api/evento/$id',
        data: {'favorito': favorito},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> atualizarInscricao(int id, bool inscrito) async {
    try {
      final response = await dio.patch(
        'https://my-json-server.typicode.com/davyfe/fake_api/evento/$id',
        data: {'inscrito': inscrito},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
