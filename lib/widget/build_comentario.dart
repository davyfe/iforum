import 'package:flutter/material.dart';
import 'package:iforum/widget/build_interaction.dart';
import 'build_text.dart';
import '/cores.dart';

class BuildComentario extends StatefulWidget {
  final String texto;
  final String autor;
  final String tempo;
  final int likes;
  final String? reacao;

  const BuildComentario({
    super.key,
    required this.texto,
    required this.autor,
    required this.tempo,
    required this.likes,
    this.reacao,
  });

  @override
  State<BuildComentario> createState() => _BuildComentarioState();
}

class _BuildComentarioState extends State<BuildComentario> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 12, backgroundColor: Cores.avatar),
                SizedBox(width: 8),
                BuildText(widget.autor, bold: true,),
                SizedBox(width: 10),
                BuildText(widget.tempo),
                Spacer(),
                Icon(Icons.more_horiz),
              ],
            ),
            BuildText(widget.texto, size: 15,
                maxLines: 3,
                overflow: TextOverflow.fade),
            SizedBox(height: 8),
            BuildInteractionBar(likes: widget.likes, reacao: widget.reacao),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
