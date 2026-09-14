import 'package:xml/xml.dart';

class NoticiaIfal {
  late String titulo;
  late String resumo;
  late String link;
  late String data;

  NoticiaIfal ({
    required this.titulo,
    required this.resumo,
    required this.link,
    required this.data,
});

  NoticiaIfal.fromXml(XmlElement item) {
    titulo = item.findElements('title').first.innerText;
    resumo = item.findElements('description').first.innerText;
    link = item.findElements('guid').first.innerText;
    data = item.findElements('pubDate').first.innerText;
  }
}