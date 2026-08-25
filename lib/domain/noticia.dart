class Noticia {
  late String titulo;
  late String texto;
  late String autor;
  late String data;
  late String urlImagem;

  Noticia({
    required this.titulo,
    required this.texto,
    required this.autor,
    required this.data,
    this.urlImagem = '',
  });

  Noticia.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    texto = json['texto'];
    autor = json['autor'] ?? '';
    data = json['data'] ?? '';
    urlImagem = json['urlImagem'] ?? '';
  }
}
