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

  factory Livro.fromJsonBusca(Map<String, dynamic> json) {
    final autores = json['author_name'] as List?;
    final isbns = json['isbn'] as List?;
    final coverId = json['cover_i'];

    return Livro(
      titulo: json['title'] ?? 'Sem título',
      autor: (autores != null && autores.isNotEmpty)
          ? autores.first
          : 'Autor desconhecido',
      ano: json['first_publish_year']?.toString() ?? '',
      isbn: (isbns != null && isbns.isNotEmpty) ? isbns.first : '',
      capaUrl: coverId != null
          ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
          : '',
      chave: json['key'] ?? '',
    );
  }

  factory Livro.fromJsonTrending(Map<String, dynamic> json) {
    final autores = json['author_name'] as List?;
    final coverId = json['cover_i'];

    return Livro(
      titulo: json['title'] ?? 'Sem título',
      autor: (autores != null && autores.isNotEmpty)
          ? autores.first
          : 'Autor desconhecido',
      ano: json['first_publish_year']?.toString() ?? '',
      // a api de trending não retorna isbn; o empréstimo fica indisponível
      // até o usuário achar o mesmo livro pela pesquisa por título/autor
      capaUrl: coverId != null
          ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
          : '',
      chave: json['key'] ?? '',
    );
  }

  factory Livro.fromJsonIsbn(Map<String, dynamic> json, String isbnBuscado) {
    return Livro(
      titulo: json['title'] ?? 'Sem título',
      ano: json['publish_date'] ?? '',
      isbn: isbnBuscado,
      capaUrl: 'https://covers.openlibrary.org/b/isbn/$isbnBuscado-M.jpg',
      chave: json['key'] ?? '',
    );
  }
}
