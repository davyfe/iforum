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
      anexo INTEGER DEFAULT 0,
      urlImagem TEXT
    ); ''';
    await db.execute(sql);

    sql =
        "INSERT INTO POST (titulo, autor, tempo, conteudo, likes, comentarios) VALUES ('Estou fazendo uma reformulação do projeto! :P', 'davyf', '30 minutos', 'Recentemente fiz uma tela para apresentação de Programação Móvel, na terça-feira passada, funcionou bem, porém o design me incomodou um pouco. Por isso, agora estou a reformulando, melhorando aspectos tanto do design quando do código.', 26, 5);";
    await db.execute(sql);

    sql =
        "INSERT INTO POST (titulo, autor, tempo, likes, comentarios, urlImagem) VALUES ('Rio de Janeiro, RJ, Brasil.', 'pdrolopes', '1 dia', 504, 230, 'https://www.daninoce.com.br/wp-content/uploads/2017/07/9-vistas-incriveis-no-rio-de-janeiro-danielle-noce-imagem-destaque.jpg');";
    await db.execute(sql);

    sql =
        "INSERT INTO POST (titulo, autor, tempo, likes, comentarios, anexo) VALUES ('Achei esse livro fantástico pra ajudar nos estudos!', 'sabynna.louyse', '1 hora', 60, 3, 1);";
    await db.execute(sql);

    sql =
        "INSERT INTO POST (titulo, autor, tempo) VALUES ('Meu computador não está funcionando... Alguém sabe o que pode ser?', 'duarte.geh', '2 segundos');";
    await db.execute(sql);

    sql = '''CREATE TABLE USER ( 
      username TEXT PRIMARY KEY,
      password TEXT
    ); ''';
    await db.execute(sql);

    sql =
        "INSERT INTO USER (username, password) VALUES ('pdrolopes', '123456');";
    await db.execute(sql);

    sql = '''CREATE TABLE NOTICIA (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo TEXT NOT NULL,
      texto TEXT NOT NULL,
      autor TEXT NOT NULL,
      data TEXT NOT NULL,
      urlImagem TEXT
    ); ''';
    await db.execute(sql);

    sql =
        "INSERT INTO NOTICIA (titulo, texto, autor, data, urlImagem) VALUES ('Professor inova com novo método apresentado em sala.', 'O uso de ferramentas digitais e estratégias organizadas permite uma análise mais precisa dos hábitos de consumo, possibilitando identificar padrões, desperdícios e oportunidades de melhoria.', 'Alaryce Jaylle', '18/05/2026', 'https://img.freepik.com/fotos-gratis/professor-de-homem-usando-oculos-verificando-o-registro-de-classe-olhando-para-a-camera-intrigado-com-a-expressao-pensativa-pensando-sentado-na-mesa-da-escola-na-frente-do-quadro-negro-na-sala-aula_141793-131719.jpg')";
    await db.execute(sql);

    sql =
        "INSERT INTO NOTICIA (titulo, texto, autor, data, urlImagem) VALUES ('Ordem e Disciplina: Dolores Umbridge é nomeada a primeira Alta Inquisidora de Hogwarts.', 'O Ministério da Magia tomou uma medida sem precedentes nesta manhã para garantir o rigor e o padrão de excellence na Escola de Magia e Bruxaria de Hogwarts.', 'Rita Skeeter', '08/09/1995', 'https://observatoriodocinema.com.br/wp-content/uploads/2023/12/dolores-umbridge-harry-potter-scaled.jpg')";
    await db.execute(sql);

    sql =
        "INSERT INTO NOTICIA (titulo, texto, autor, data, urlImagem) VALUES ('Grêmio Estudantil divulga ação sobre a importância da participação ativa.', 'A ação promovida pelo Grêmio Estudantil teve como principal objetivo incentivar os alunos a participarem mais ativamente das decisões da escola.', 'José Paulo', '15/05/2026', 'https://observatorio.movimentopelabase.org.br/wp-content/uploads/2022/07/shutterstock-1937721487-970x570.jpg')";
    await db.execute(sql);

    sql =
        "INSERT INTO NOTICIA (titulo, texto, autor, data, urlImagem) VALUES ('A percepção das dificuldades promove uma abordagem mais crítica e inclusiva na realidade educacional.', 'Os estudos mais recentes relacionados ao ambiente escolar demonstram que compreender as dificuldades enfrentadas pelos estudantes é fundamental para criar um ambiente mais inclusivo.', 'Adriana Santana', '16/05/2026', 'https://www.agricultura.sc.gov.br/wp-content/uploads/2024/06/WhatsApp-Image-2024-06-04-at-16.51.49.jpeg')";
    await db.execute(sql);

    sql =
        "INSERT INTO NOTICIA (titulo, texto, autor, data, urlImagem) VALUES ('Panorama sobre o universo dos jogos destaca seu papel no aprendizado.', 'Pesquisadores e educadores vêm discutindo cada vez mais a presença dos jogos digitais como ferramenta pedagógica nas escolas.', 'Karinne Coelho', '15/05/2026', 'https://cdn.focoradical.com.br/newfoco/banners/20251217173547IMG9373.jpg')";
    await db.execute(sql);
  }
}
