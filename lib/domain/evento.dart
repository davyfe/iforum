import 'package:flutter/material.dart';
import '/cores.dart';

class Evento {
  int? id;
  late String titulo;
  late String data;
  late String horario;
  late String local;
  late String autor;
  late Color cor;
  late bool inscrito;
  late bool favorito;

  Evento({
    this.id,
    required this.titulo,
    required this.data,
    required this.horario,
    required this.local,
    required this.autor,
    required this.cor,
    this.inscrito = false,
    this.favorito = false,
  });

  Evento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'] ?? 'Evento sem título';
    data = json['data'] ?? '';
    horario = json['horario'] ?? '';
    local = json['local'] ?? '';
    autor = json['autor'] ?? '';
    cor = json['cor'] != null ? Color(json['cor']) : Cores.verde;
    inscrito = json['inscrito'] == 1 || json['inscrito'] == true;
    favorito = json['favorito'] == 1 || json['favorito'] == true;
  }
}
