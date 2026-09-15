import 'package:dio/dio.dart';
import '/domain/emprestimo.dart';

class EmprestimoApi {
  final dio = Dio();

  Future<List<Emprestimo>> listarEmprestimos() async {
    final response = await dio.get('https://my-json-server.typicode.com/davyfe/fake_api/emprestimo');

    List<Emprestimo> lista = [];
    if (response.statusCode == 200) {
      for (var json in response.data) {
        lista.add(Emprestimo.fromJson(json));
      }
    }
    return lista;
  }

  Future<List<Emprestimo>> listarAtuais() async {
    final lista = await listarEmprestimos();
    return lista.where((e) => e.dataDevolucao == null).toList();
  }

  Future<List<Emprestimo>> listarAntigos() async {
    final lista = await listarEmprestimos();
    return lista.where((e) => e.dataDevolucao != null).toList();
  }

  Future<int?> emprestar(Emprestimo emprestimo) async {
    try {
      final response = await dio.post(
        'https://my-json-server.typicode.com/davyfe/fake_api/emprestimo',
        data: {
          'tituloLivro': emprestimo.tituloLivro,
          'autorLivro': emprestimo.autorLivro,
          'capaUrl': emprestimo.capaUrl,
          'isbn': emprestimo.isbn,
          'dataEmprestimo': emprestimo.dataEmprestimo,
          'dataPrevista': emprestimo.dataPrevista,
          'dataDevolucao': emprestimo.dataDevolucao,
          'renovacoes': emprestimo.renovacoes,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['id'] as int?;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<bool> devolver(int id, String dataDevolucao) async {
    try {
      final response = await dio.patch(
        'https://my-json-server.typicode.com/davyfe/fake_api/emprestimo/$id',
        data: {'dataDevolucao': dataDevolucao},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> renovar(
      int id,
      String novaDataPrevista,
      int novasRenovacoes,
      ) async {
    try {
      final response = await dio.patch(
        'https://my-json-server.typicode.com/davyfe/fake_api/emprestimo/$id',
        data: {
          'dataPrevista': novaDataPrevista,
          'renovacoes': novasRenovacoes,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> estaEmprestado(String isbn) async {
    if (isbn.isEmpty) return false;
    final lista = await listarAtuais();
    return lista.any((e) => e.isbn == isbn);
  }
}