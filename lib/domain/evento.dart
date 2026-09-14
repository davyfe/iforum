import 'package:flutter/material.dart';

class Evento {
  late String titulo;
  late String data;
  late String horario;
  late String local;
  late String autor;
  late IconData icone;
  late Color cor;

  Evento({
    required this.titulo,
    required this.data,
    required this.horario,
    required this.local,
    required this.autor,
    required this.cor,
    required this.icone,
  });

  Evento.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    data = json['data'];
    horario = json['horario'];
    local = json['local'];
    autor = json['autor'];
    icone = IconData(json['iconCodePoint'], fontFamily: json['iconFontFamily']);
    cor = Color(json['cor']);
  }
}
