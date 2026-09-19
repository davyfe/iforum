class Post {
  final int? id;
  final String titulo;
  final String autor;
  final String tempo;
  final String conteudo;
  final int likes;
  final int comentarios;
  final bool anexo;
  final String urlImagem;
  bool favorito; // Adicionado para suportar o filtro de favoritos

  Post({
    this.id,
    required this.titulo,
    required this.autor,
    required this.tempo,
    required this.conteudo,
    required this.likes,
    required this.comentarios,
    required this.anexo,
    required this.urlImagem,
    this.favorito = false, // Valor padrão
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      titulo: json['titulo'] ?? '',
      autor: json['autor'] ?? '',
      tempo: json['tempo'] ?? '',
      conteudo: json['conteudo'] ?? '',
      likes: json['likes'] ?? 0,
      comentarios: json['comentarios'] ?? 0,
      anexo: json['anexo'] == 1 || json['anexo'] == true,
      urlImagem: json['urlImagem'] ?? '',
      favorito: json['favorito'] == 1 || json['favorito'] == true,
    );
  }
}