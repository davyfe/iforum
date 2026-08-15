import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    String dbName = 'iforum.gb';

    String dbPath = join(path, dbName);

    Database db = await openDatabase(dbPath, version: 1, onCreate: onCreateDB);

    return db;
  }

  Future<void> onCreateDB(Database db, int version) async {
    String sql = '''CREATE TABLE POST (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo TEXT NOT NULL,
      autor TEXT NOT NULL,
      tempo TEXT,
      conteudo TEXT,
      likes INTEGER DEFAULT 0,
      comentarios INTEGER DEFAULT 0,
      anexo INTEGER DEFAULT 0
      urlImagem TEXT,
    ); ''';

    await db.execute(sql);

    sql =
        "INSERT INTO Post (titulo, autor, tempo, conteudo, likes, comentarios, anexo, urlImagem) VALUES ('Estou fazendo uma reformulação do projeto! :P', 'davyf', '30 minutos', 'Recentemente fiz uma tela para apresentação de Programação Móvel, na terça-feira passada, funcionou bem, porém o design me incomodou um pouco. Por isso, agora estou a reformulando, melhorando aspectos tanto do design quando do código.', 26, 5, 1);";
    await db.execute(sql);

    sql =
        "INSERT INTO PROPRIEDADE_POST (titulo, autor, tempo, likes, comentarios, urlImagem) VALUES ('Rio de Janeiro, RJ, Brasil.', 'pdrolopesm', '1 dia', 504, 230, 'https://www.daninoce.com.br/wp-content/uploads/2017/07/9-vistas-incriveis-no-rio-de-janeiro-danielle-noce-imagem-destaque.jpg');";
    await db.execute(sql);

    sql =
        "INSERT INTO PROPRIEDADE_POST (titulo, autor, tempo, likes, comentarios, anexo) VALUES ('Achei esse livro fantástico pra ajudar nos estudos!', 'sabynna.louyse', '1 hora', 'material', 60, 3, 1);";
    await db.execute(sql);

    sql =
        "INSERT INTO PROPRIEDADE_POST (titulo, autor, tempo) VALUES ('Meu computador não está funcionando... Alguém sabe o que pode ser?', 'duarte.geh', '2 segundos');";
    await db.execute(sql);
  }
}
