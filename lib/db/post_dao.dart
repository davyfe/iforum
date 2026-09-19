import '/domain/post.dart';
import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';

class PostDao {
  Future<List<Post>> listarPosts() async {
    Database db = await DbHelper().initDB();
    final result = await db.query('POST', orderBy: 'id DESC');
    return result.map((json) => Post.fromJson(json)).toList();
  }

  Future<int> inserirPost(Post post) async {
    Database db = await DbHelper().initDB();
    return db.insert('POST', {
      'titulo': post.titulo,
      'autor': post.autor,
      'tempo': post.tempo,
      'conteudo': post.conteudo,
      'likes': post.likes,
      'comentarios': post.comentarios,
      'anexo': post.anexo ? 1 : 0,
      'urlImagem': post.urlImagem,
    });
  }

  Future<int> deletarPost(int id) async {
    Database db = await DbHelper().initDB();
    return db.delete('POST', where: 'id=?', whereArgs: [id]);
  }

  Future<List<Post>> listarPorAutor(String autor) async {
    Database db = await DbHelper().initDB();
    final result = await db.query(
      'POST',
      where: 'autor = ?',
      whereArgs: [autor],
      orderBy: 'id DESC',
    );
    return result.map((json) => Post.fromJson(json)).toList();
  }

  Future<List<Post>> buscarPorTitulo(String nomeInicial) async {
    Database db = await DbHelper().initDB();
    final result = await db.query(
      'POST',
      where: 'titulo LIKE ?',
      whereArgs: ['$nomeInicial%'],
    );
    return result.map((json) => Post.fromJson(json)).toList();
  }

  Future<int> atualizarFavorito(int id, bool favorito) async {
    Database db = await DbHelper().initDB();
    return db.update(
      'POST',
      {'favorito': favorito ? 1 : 0},
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
