class Comentario {
  int? id;
  late String noticiaTitulo;
  late String autor;
  late String texto;
  late String tempo;
  late int likes;

  Comentario({
    this.id,
    required this.noticiaTitulo,
    required this.autor,
    required this.texto,
    required this.tempo,
    this.likes = 0,
  });

  Comentario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noticiaTitulo = json['noticiaTitulo'];
    autor = json['autor'];
    texto = json['texto'];
    tempo = json['tempo'];
    likes = json['likes'] ?? 0;
  }
}
