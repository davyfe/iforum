import 'package:dio/dio.dart';
import '/domain/livro.dart';

// https://openlibrary.org/developers

class BibliotecaApi {
  final dio = Dio();

  Future<List<Livro>> listarPopulares() async {
    final response = await dio.get('https://openlibrary.org/trending/now.json');

    List<Livro> lista = [];

    if (response.statusCode == 200) {
      final works = response.data['works'] as List;
      for (var json in works) {
        lista.add(Livro.fromJson(json));
      }
    }
    return lista;
  }

  Future<List<Livro>> pesquisarLivros(
    String termo, {
    String tipo = 'geral', // como buscar
  }) async {
    String parametro;
    switch (tipo) {
      case 'titulo':
        parametro = 'title';
        break;
      case 'autor':
        parametro = 'author';
        break;
      default:
        parametro = 'q'; // busca geral
    }

    final response = await dio.get(
      'https://openlibrary.org/search.json',
      queryParameters: {
        parametro: termo,
        'limit': 20,
        'fields': 'key,title,author_name,first_publish_year,cover_i,isbn',
      },
    );

    List<Livro> lista = [];

    if (response.statusCode == 200) {
      final docs = response.data['docs'] as List;
      for (var json in docs) {
        lista.add(Livro.fromJson(json));
      }
    }
    return lista;
  }

  Future<Livro?> buscarPorIsbn(String isbn) async {
    final response = await dio.get('https://openlibrary.org/isbn/$isbn.json');

    if (response.statusCode == 200) {
      return Livro.fromJsonIsbn(response.data, isbn);
    }
    return null;
  }
}
