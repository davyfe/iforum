class Livro {
  late String titulo;
  late String autor;
  late String ano;
  late String isbn;
  late String capaUrl;
  late String chave;

  Livro({
    required this.titulo,
    this.autor = 'Autor desconhecido',
    this.ano = '',
    this.isbn = '',
    this.capaUrl = '',
    this.chave = '',
  });

  Livro.fromJson(Map<String, dynamic> json) {
    // a api retorna como lista:
    final autores = json['author_name'] as List?;
    final isbns = json['isbn'] as List?;
    final coverId = json['cover_i'];
    titulo = json['title'] ?? 'Sem título';
    // primeiro nome
    autor = (autores != null && autores.isNotEmpty)
        ? autores.first
        : 'Autor desconhecido';
    ano = json['first_publish_year']?.toString() ?? '';
    isbn = (isbns != null && isbns.isNotEmpty) ? isbns.first : '';
    capaUrl = coverId != null
        ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
        : '';
    chave = json['key'] ?? '';
  }

  Livro.fromJsonIsbn(Map<String, dynamic> json, String isbn) {
    titulo = json['title'] ?? 'Sem título';
    autor = 'Autor desconhecido';
    ano = json['publish_date'] ?? '';
    isbn = isbn;
    capaUrl = 'https://covers.openlibrary.org/b/isbn/$isbn-M.jpg';
    chave = json['key'] ?? '';
  }
}
