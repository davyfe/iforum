import 'package:dio/dio.dart';
import '/domain/evento.dart';

class EventosApi {
  final dio = Dio();
  String url = 'https://my-json-server.typicode.com/davyfe/fake_api/evento';

  Future<List<Evento>> listarEventos() async {
    final response = await dio.get(url);
    List<Evento> lista = [];
    for (var json in response.data) {
      lista.add(Evento.fromJson(json));
    }
    return lista;
  }

  Future<bool> atualizarFavorito(int id, bool favorito) async {
    try {
      await dio.patch('$url/$id', data: {'favorito': favorito});
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> atualizarInscricao(int id, bool inscrito) async {
    try {
      await dio.patch('$url/$id', data: {'inscrito': inscrito});
      return true;
    } catch (_) {
      return false;
    }
  }
}
