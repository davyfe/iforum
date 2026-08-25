import 'package:sqflite/sqflite.dart';
import '/domain/noticia.dart';
import 'db_helper.dart';

class NoticiaDao {
  Future<List<Noticia>> listarNoticias() async {
    Database db = await DbHelper().initDB();

    var result = await db.rawQuery('SELECT * FROM NOTICIA');

    List<Noticia> lista = [];
    for (var json in result) {
      Noticia noticia = Noticia.fromJson(json);
      lista.add(noticia);
    }
    return lista;
  }

  Future<int> inserirNoticia(Noticia noticia) async {
    Database db = await DbHelper().initDB();
    return db.insert('NOTICIA', {
      'titulo': noticia.titulo,
      'texto': noticia.texto,
      'autor': noticia.autor,
      'data': noticia.data,
      'urlImagem': noticia.urlImagem,
    });
  }

  Future<int> deletarNoticia(int id) async {
    Database db = await DbHelper().initDB();
    return db.delete('NOTICIA', where: 'id=?', whereArgs: [id]);
  }
}
