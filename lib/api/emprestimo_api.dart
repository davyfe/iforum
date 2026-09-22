import 'package:dio/dio.dart';
import '/domain/emprestimo.dart';

class EmprestimoApi {
  final dio = Dio();
  String url = 'https://my-json-server.typicode.com/davyfe/fake_api/emprestimo';

  Future<List<Emprestimo>> listarEmprestimos() async {
    final response = await dio.get(url);
    List<Emprestimo> lista = [];
    for (var json in response.data) {
      lista.add(Emprestimo.fromJson(json));
    }
    return lista;
  }

  Future<List<Emprestimo>> listarAtuais() async {
    final todos = await listarEmprestimos();
    List<Emprestimo> lista = [];
    for (var e in todos) {
      if (e.dataDevolucao == null) lista.add(e);
    }
    return lista;
  }

  Future<List<Emprestimo>> listarAntigos() async {
    final todos = await listarEmprestimos();
    List<Emprestimo> lista = [];
    for (var e in todos) {
      if (e.dataDevolucao != null) lista.add(e);
    }
    return lista;
  }

  Future<int?> emprestar(Emprestimo emprestimo) async {
    final response = await dio.post(
      url,
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
    return response.data['id'] as int?;
  }

  Future<void> devolver(int id, String devolucao) {
    return dio.patch('$url/$id', data: {'dataDevolucao': devolucao});
  }

  Future<void> renovar(int id, String novaData, int renovacoes) {
    return dio.patch(
      '$url/$id',
      data: {'dataPrevista': novaData, 'renovacoes': renovacoes},
    );
  }

  Future<bool> verificar(String isbn) async {
    if (isbn.isEmpty) return false;
    final lista = await listarAtuais();
    for (var e in lista) {
      if (e.isbn == isbn) return true;
    }
    return false;
  }
}
