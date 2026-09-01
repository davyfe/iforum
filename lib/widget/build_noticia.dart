import 'package:flutter/material.dart';
import 'package:iforum/widget/build_interaction.dart';
import 'package:iforum/widget/build_text.dart';
import '/domain/noticia.dart';
import '/pages/nav_page.dart';
import '/cores.dart';

class BuildNoticia extends StatelessWidget {
  final Noticia noticia;

  const BuildNoticia({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavPage(noticia: noticia)),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 10,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 12, backgroundColor: Cores.avatar),
                    const SizedBox(width: 8),
                    BuildText(noticia.autor, bold: true),
                    const SizedBox(width: 10),
                    BuildText(noticia.data),
                    const Spacer(),
                    const Icon(Icons.more_horiz),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: BuildText(noticia.titulo, bold: true, size: 17),
                    ),
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        noticia.urlImagem,
                        width: 120,
                        height: 102,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                BuildInteractionBar(
                  likes: 30,
                  comentarios: 10,
                  trailing: const Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.black54, thickness: 0.2, height: 1),
        ],
      ),
    );
  }
}
