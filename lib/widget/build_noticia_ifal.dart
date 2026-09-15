import 'package:flutter/material.dart';
import '/domain/noticia_ifal.dart';
import '/widget/build_text.dart';

class BuildNoticiaIfal extends StatelessWidget {
  final NoticiaIfal noticia;

  const BuildNoticiaIfal({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildText(noticia.titulo, bold: true, size: 16),
              const SizedBox(height: 4),
              BuildText(noticia.data, color: Colors.black45),
              const SizedBox(height: 8),
              BuildText(noticia.resumo, color: Colors.black87),
            ],
          ),
        ),
        const Divider(color: Colors.black54, thickness: 0.2, height: 1),
      ],
    );
  }
}