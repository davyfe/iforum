import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'iforum.db');
    return openDatabase(path, version: 1, onCreate: onCreateDB);
  }

  Future<void> onCreateDB(Database db, int version) async {
    await db.execute('''CREATE TABLE USER (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
    );''');

    await db.execute('''CREATE TABLE COMENTARIO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      noticiaTitulo TEXT NOT NULL,
      autor TEXT NOT NULL,
      texto TEXT NOT NULL,
      tempo TEXT NOT NULL,
      likes INTEGER DEFAULT 0
    );''');

    await db.execute('''CREATE TABLE NOTIFICACAO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo TEXT NOT NULL,
      mensagem TEXT NOT NULL,
      tipo TEXT NOT NULL,
      data TEXT NOT NULL,
      lida INTEGER DEFAULT 0
    );''');
  }
}
