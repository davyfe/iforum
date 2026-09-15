class Post {
  late String titulo;
  late String autor;
  late String tempo;
  late String conteudo;
  late int likes;
  late int comentarios;
  late bool anexo;
  late String urlImagem;

  Post({
    required this.titulo,
    required this.autor,
    required this.tempo,
    this.conteudo = "",
    this.likes = 0,
    this.comentarios = 0,
    this.anexo = false,
    this.urlImagem = "",
  });

  Post.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    autor = json['autor'];
    tempo = json['tempo'];
    conteudo = json['conteudo'] ?? "";
    likes = json['likes'] ?? 0;
    comentarios = json['comentarios'] ?? 0;
    anexo = json['anexo'] == 1 || json['anexo'] == true;
    urlImagem = json['urlImagem'] ?? "";
  }
}
