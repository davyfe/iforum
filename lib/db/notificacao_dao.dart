import 'package:sqflite/sqflite.dart';
import '/domain/notificacao.dart';
import 'db_helper.dart';

class NotificacaoDao {
  Future<int> inserirNotificacao(Notificacao notificacao) async {
    Database db = await DbHelper().initDB();
    return db.insert('NOTIFICACAO', {
      'titulo': notificacao.titulo,
      'mensagem': notificacao.mensagem,
      'tipo': notificacao.tipo,
      'data': notificacao.data,
      'lida': notificacao.lida ? 1 : 0,
    });
  }

  Future<List<Notificacao>> listarNotificacoes() async {
    Database db = await DbHelper().initDB();
    var result = await db.query('NOTIFICACAO', orderBy: 'id DESC');
    return result.map((json) => Notificacao.fromJson(json)).toList();
  }

  Future<int> marcarComoLida(int id) async {
    Database db = await DbHelper().initDB();
    print('lido!');
    return db.update(
      'NOTIFICACAO',
      {'lida': 1},
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
