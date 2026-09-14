class Emprestimo {
  int? id;
  late String tituloLivro;
  late String autorLivro;
  late String capaUrl;
  late String isbn;
  late String dataEmprestimo;
  late String dataPrevista;
  String? dataDevolucao;
  late int renovacoes;

  Emprestimo({
    this.id,
    required this.tituloLivro,
    required this.autorLivro,
    this.capaUrl = '',
    this.isbn = '',
    required this.dataEmprestimo,
    required this.dataPrevista,
    this.dataDevolucao,
    this.renovacoes = 0,
  });

  Emprestimo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tituloLivro = json['tituloLivro'];
    autorLivro = json['autorLivro'] ?? '';
    capaUrl = json['capaUrl'] ?? '';
    isbn = json['isbn'] ?? '';
    dataEmprestimo = json['dataEmprestimo'];
    dataPrevista = json['dataPrevista'];
    dataDevolucao = json['dataDevolucao'];
    renovacoes = json['renovacoes'] ?? 0;
  }
}
