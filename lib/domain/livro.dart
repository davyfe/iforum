class Livro {
  late String titulo;
  late String autor;
  late String ano;
  late String isbn;
  late String capaUrl;

  Livro({
    required this.titulo,
    this.autor = 'Autor desconhecido',
    this.ano = '',
    this.isbn = '',
    this.capaUrl = '',
  });

  Livro.fromJson(Map<String, dynamic> json) {
    final autores = json['author_name'] as List?;
    final isbns = json['isbn'] as List?;
    final coverId = json['cover_i'];
    titulo = json['title'] ?? 'Sem título';
    // autor formatado:
    autor = (autores != null && autores.isNotEmpty)
        ? autores.first
        : 'Autor desconhecido';
    ano = json['first_publish_year']?.toString() ?? '';
    isbn = (isbns != null && isbns.isNotEmpty) ? isbns.first : '';
    capaUrl = coverId != null
        ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
        : '';
  }

  Livro.fromJsonIsbn(Map<String, dynamic> json, String isbnLivro) {
    titulo = json['title'] ?? 'Sem título';
    autor = 'Autor desconhecido';
    ano = json['publish_date'] ?? '';
    isbn = isbnLivro;
    capaUrl = 'https://covers.openlibrary.org/b/isbn/$isbnLivro-M.jpg';
  }
}
