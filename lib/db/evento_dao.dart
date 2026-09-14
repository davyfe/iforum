import 'package:sqflite/sqflite.dart';
import '/domain/evento.dart';
import 'db_helper.dart';

class EventoDao {
  Future<List<Evento>> listarEventos() async {
    Database db = await DbHelper().initDB();

    var result = await db.rawQuery('SELECT * FROM EVENTO');

    List<Evento> lista = [];
    for (var json in result) {
      Evento evento = Evento.fromJson(json);
      lista.add(evento);
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
      'iconCodePoint': evento.icone.codePoint,
      'iconFontFamily': evento.icone.fontFamily,
      'cor': evento.cor.toARGB32(),
    });
  }
}
