import '/domain/post.dart';
import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';

class PostDao {
  Future<List<Post>> listarPosts() async {
    Database db = await DbHelper().initDB();

    var result = await db.rawQuery('SELECT * FROM POST');

    List<Post> lista = [];
    for (var json in result) {
      Post post = Post.fromJson(json);
      lista.add(post);
    }
    return lista;
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
}
