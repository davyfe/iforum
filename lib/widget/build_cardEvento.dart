import 'package:flutter/material.dart';
import '/domain/evento.dart';
import '/cores.dart';
import 'build_text.dart';

class BuildCardEvento extends StatefulWidget {
  final Evento evento;

  const BuildCardEvento({super.key, required this.evento});

  @override
  State<BuildCardEvento> createState() => _BuildCardEventoState();
}

class _BuildCardEventoState extends State<BuildCardEvento> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(20),
        color: widget.evento.cor,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildText(widget.evento.titulo, bold: true, size: 18),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.date_range, color: Cores.textoTerciario),
                BuildText(widget.evento.data, color: Cores.textoTerciario),
                SizedBox(width: 5),
                Icon(Icons.access_time, color: Cores.textoTerciario),
                BuildText(widget.evento.horario, color: Cores.textoTerciario),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: Cores.textoTerciario),
                SizedBox(width: 5),
                BuildText(widget.evento.local, color: Cores.textoTerciario),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
