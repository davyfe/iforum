import 'package:dio/dio.dart';
import 'package:xml/xml.dart';
import '/domain/noticia_ifal.dart';

class NoticiaIfalApi {
  final dio = Dio();

  Future<List<NoticiaIfal>> listarNoticiasIfal() async {
    final response = await dio.get(
      'https://www2.ifal.edu.br/rss/noticias/rss.xml',
    );

    List<NoticiaIfal> lista = [];

    if (response.statusCode == 200) {
      final documento = XmlDocument.parse(response.data);
      final itens = documento.findAllElements('item');

      for (var item in itens) {
        lista.add(NoticiaIfal.fromXml(item));
      }
    }
    return lista;
  }
}