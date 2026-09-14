class Notificacao {
  int? id;
  late String titulo;
  late String mensagem;
  late String tipo;
  late String data;
  late bool lida;

  Notificacao({
    this.id,
    required this.titulo,
    required this.mensagem,
    required this.tipo,
    required this.data,
    this.lida = false,
  });

  Notificacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    mensagem = json['mensagem'];
    tipo = json['tipo'];
    data = json['data'];
    lida = json['lida'] == 1;
  }
}
