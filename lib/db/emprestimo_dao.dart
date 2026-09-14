import 'package:sqflite/sqflite.dart';
import '/domain/emprestimo.dart';
import 'db_helper.dart';

class EmprestimoDao {
  Future<int> emprestar(Emprestimo emprestimo) async {
    Database db = await DbHelper().initDB();
    return db.insert('EMPRESTIMO', {
      'tituloLivro': emprestimo.tituloLivro,
      'autorLivro': emprestimo.autorLivro,
      'capaUrl': emprestimo.capaUrl,
      'isbn': emprestimo.isbn,
      'dataEmprestimo': emprestimo.dataEmprestimo,
      'dataPrevista': emprestimo.dataPrevista,
      'dataDevolucao': emprestimo.dataDevolucao,
      'renovacoes': emprestimo.renovacoes,
    });
  }

  Future<List<Emprestimo>> listarAtuais() async {
    Database db = await DbHelper().initDB();
    var result = await db.query('EMPRESTIMO', where: 'dataDevolucao IS NULL');
    return result.map((json) => Emprestimo.fromJson(json)).toList();
  }

  Future<List<Emprestimo>> listarAntigos() async {
    Database db = await DbHelper().initDB();
    var result = await db.query(
      'EMPRESTIMO',
      where: 'dataDevolucao IS NOT NULL',
    );
    return result.map((json) => Emprestimo.fromJson(json)).toList();
  }

  Future<int> devolver(int id, String dataDevolucao) async {
    Database db = await DbHelper().initDB();
    return db.update(
      'EMPRESTIMO',
      {'dataDevolucao': dataDevolucao},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<int> renovar(
    int id,
    String novaDataPrevista,
    int novasRenovacoes,
  ) async {
    Database db = await DbHelper().initDB();
    return db.update(
      'EMPRESTIMO',
      {'dataPrevista': novaDataPrevista, 'renovacoes': novasRenovacoes},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<bool> estaEmprestado(String isbn) async {
    if (isbn.isEmpty) return false;
    Database db = await DbHelper().initDB();
    var result = await db.query(
      'EMPRESTIMO',
      where: 'isbn=? AND dataDevolucao IS NULL',
      whereArgs: [isbn],
    );
    return result.isNotEmpty;
  }
}
