import 'package:dio/dio.dart';
import 'package:iforum/domain/noticia.dart';

class NoticiaApi {
  final dio = Dio();

  Future<List<Noticia>> listarNoticias() async {
    final response = await dio.get(
        'https://my-json-server.typicode.com/davyfe/fake_api/noticia',
    );

    List<Noticia> lista = [];

    if (response.statusCode == 200) {
      for (var json in response.data) {
        Noticia noticia = Noticia.fromJson(json);
        lista.add(noticia);
      }
    }
    return lista;
  }
}