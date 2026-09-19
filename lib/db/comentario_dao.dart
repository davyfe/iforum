import 'package:sqflite/sqflite.dart';
import '/domain/comentario.dart';
import 'db_helper.dart';

class ComentarioDao {
  Future<List<Comentario>> listarPorNoticia(String noticiaTitulo) async {
    Database db = await DbHelper().initDB();
    final result = await db.query(
      'COMENTARIO',
      where: 'noticiaTitulo = ?',
      whereArgs: [noticiaTitulo],
      orderBy: 'id DESC',
    );
    return result.map((json) => Comentario.fromJson(json)).toList();
  }

  Future<int> inserirComentario(Comentario comentario) async {
    Database db = await DbHelper().initDB();
    return db.insert('COMENTARIO', {
      'noticiaTitulo': comentario.noticiaTitulo,
      'autor': comentario.autor,
      'texto': comentario.texto,
      'tempo': comentario.tempo,
      'likes': comentario.likes,
    });
  }
}
