import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, 'iforum.db');
    return openDatabase(dbPath, version: 1, onCreate: onCreateDB);
  }

  Future<void> onCreateDB(Database db, int version) async {
    await db.execute('''CREATE TABLE POST (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo TEXT NOT NULL,
      autor TEXT NOT NULL,
      tempo TEXT,
      conteudo TEXT,
      likes INTEGER DEFAULT 0,
      comentarios INTEGER DEFAULT 0,
      anexo INTEGER DEFAULT 0,
      urlImagem TEXT,
      favorito INTEGER DEFAULT 0
    );''');

    await db.insert('POST', {
      'titulo': 'Estou fazendo uma reformulação do projeto! :P',
      'autor': 'davyf',
      'tempo': '30 minutos',
      'conteudo':
          'Recentemente fiz uma tela para apresentação de Programação Móvel, na terça-feira passada, funcionou bem, porém o design me incomodou um pouco. Por isso, agora estou a reformulando, melhorando aspectos tanto do design quando do código.',
      'likes': 26,
      'comentarios': 5,
    });
    await db.insert('POST', {
      'titulo': 'Rio de Janeiro, RJ, Brasil.',
      'autor': 'pdrolopes',
      'tempo': '1 dia',
      'likes': 504,
      'comentarios': 230,
      'urlImagem':
          'https://www.daninoce.com.br/wp-content/uploads/2017/07/9-vistas-incriveis-no-rio-de-janeiro-danielle-noce-imagem-destaque.jpg',
    });
    await db.insert('POST', {
      'titulo': 'Achei esse livro fantástico pra ajudar nos estudos!',
      'autor': 'sabynna.louyse',
      'tempo': '1 hora',
      'likes': 60,
      'comentarios': 3,
      'anexo': 1,
    });
    await db.insert('POST', {
      'titulo':
          'Meu computador não está funcionando... Alguém sabe o que pode ser?',
      'autor': 'duarte.geh',
      'tempo': '2 segundos',
    });

    await db.execute('''CREATE TABLE EVENTO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo TEXT NOT NULL,
      data TEXT NOT NULL,
      horario TEXT NOT NULL,
      local TEXT NOT NULL,
      autor TEXT NOT NULL,
      cor INTEGER NOT NULL,
      inscrito INTEGER DEFAULT 0,
      favorito INTEGER DEFAULT 0
    );''');

    await db.insert('EVENTO', {
      'titulo': 'IV Semana Nacional de Ciência e Tecnologia',
      'data': '30/03/2026',
      'horario': '8:30',
      'local': 'Ifal Campus Arapiraca',
      'autor': 'Adriana Santana',
      'cor': Colors.lightBlueAccent.toARGB32(),
    });
    await db.insert('EVENTO', {
      'titulo': 'Semana do Meio Ambiente 2026',
      'data': '10/06/2026',
      'horario': '9:30',
      'local': 'Ifal Campus Arapiraca',
      'autor': 'Comissão de Meio Ambiente',
      'cor': Colors.lightGreen.toARGB32(),
    });
    await db.insert('EVENTO', {
      'titulo': 'Abril Índigena',
      'data': '16/04/2026',
      'horario': '9:30',
      'local': 'Ifal Campus Arapiraca',
      'autor': 'Sante',
      'cor': Colors.redAccent.toARGB32(),
    });
    await db.insert('EVENTO', {
      'titulo': 'V Festival de Arte',
      'data': '04/12/2026',
      'horario': '8:00',
      'local': 'Ifal Campus Penedo',
      'autor': 'Comissão de Arte',
      'cor': Colors.yellow.toARGB32(),
    });

    await db.execute('''CREATE TABLE EMPRESTIMO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tituloLivro TEXT NOT NULL,
      autorLivro TEXT,
      capaUrl TEXT,
      isbn TEXT,
      dataEmprestimo TEXT NOT NULL,
      dataPrevista TEXT NOT NULL,
      dataDevolucao TEXT,
      renovacoes INTEGER DEFAULT 0
    );''');

    await db.execute('''CREATE TABLE NOTIFICACAO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo TEXT NOT NULL,
      mensagem TEXT NOT NULL,
      tipo TEXT NOT NULL,
      data TEXT NOT NULL,
      lida INTEGER DEFAULT 0
    );''');

    await db.execute('''CREATE TABLE COMENTARIO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      noticiaTitulo TEXT NOT NULL,
      autor TEXT NOT NULL,
      texto TEXT NOT NULL,
      tempo TEXT NOT NULL,
      likes INTEGER DEFAULT 0
    );''');
  }
}
