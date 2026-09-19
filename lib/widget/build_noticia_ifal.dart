import 'package:flutter/material.dart';
import '/domain/noticia_ifal.dart';
import '/cores.dart';
import 'build_text.dart';

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
              Row(
                children: [
                  CircleAvatar(radius: 12, backgroundColor: Cores.avatar),
                  const SizedBox(width: 8),
                  BuildText('IFAL', bold: true),
                  const SizedBox(width: 10),
                  Expanded(
                    child: BuildText(
                      noticia.data,
                      color: Cores.textoTerciario,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              BuildText(noticia.titulo, bold: true, size: 17),
              const SizedBox(height: 6),
              BuildText(
                noticia.resumo,
                color: Colors.black87,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Divider(color: Colors.black54, thickness: 0.2, height: 1),
      ],
    );
  }
}
