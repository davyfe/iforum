import 'package:sqflite/sqflite.dart';
import '/domain/evento.dart';
import 'db_helper.dart';

class EventoDao {
  Future<List<Evento>> listarEventos() async {
    Database db = await DbHelper().initDB();
    var result = await db.rawQuery('SELECT * FROM EVENTO');

    List<Evento> lista = [];
    for (var json in result) {
      lista.add(Evento.fromJson(json));
    }
    return lista;
  }

  Future<int> inserirEvento(Evento evento) async {
    Database db = await DbHelper().initDB();
    return db.insert('EVENTO', {
      'titulo': evento.titulo,
      'data': evento.data,
      'horario': evento.horario,
      'local': evento.local,
      'autor': evento.autor,
      'cor': evento.cor.toARGB32(),
      'inscrito': evento.inscrito ? 1 : 0,
      'favorito': evento.favorito ? 1 : 0,
    });
  }

  Future<int> atualizarInscricao(int id, bool inscrito) async {
    Database db = await DbHelper().initDB();
    return db.update(
      'EVENTO',
      {'inscrito': inscrito ? 1 : 0},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<int> atualizarFavorito(int id, bool favorito) async {
    Database db = await DbHelper().initDB();
    return db.update(
      'EVENTO',
      {'favorito': favorito ? 1 : 0},
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
