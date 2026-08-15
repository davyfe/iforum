import 'package:flutter/material.dart';

import '/domain/post.dart';
import '/cores.dart';
import 'buildInteractionBar.dart';
import 'buildText.dart';

class BuildPost extends StatefulWidget {
  Post post;

  BuildPost({super.key, required this.post});

  @override
  State<BuildPost> createState() => _BuildPostState();
}

class _BuildPostState extends State<BuildPost> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 12, backgroundColor: Cores.avatar),
                    const SizedBox(width: 9),
                    BuildText(widget.post.autor, bold: true),
                    const SizedBox(width: 10),
                    BuildText(widget.post.tempo),
                    const Spacer(),
                    const Icon(Icons.more_horiz),
                  ],
                ),
                const SizedBox(height: 5),
                BuildText(
                  widget.post.titulo,
                  size: 20,
                  bold: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.post.conteudo.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  BuildText(
                    widget.post.conteudo,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (widget.post.urlImagem.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.post.urlImagem,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ],
                if (widget.post.anexo) ...[
                  const SizedBox(height: 5),
                  _buildAnexo('livro.pdf', '250 mb'),
                ],
                const SizedBox(height: 8),
                BuildInteractionBar(
                  likes: widget.post.likes,
                  comentarios: widget.post.comentarios,
                  trailing: const Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.black54, thickness: 0.5, height: 1),
        ],
      ),
    );
  }

  // fazer o anexo
  Widget _buildAnexo(String nome, String tamanho) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      width: 145,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black54, width: 0.3),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.red, size: 30),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [BuildText(nome, bold: true), BuildText(tamanho)],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.file_download_outlined, size: 18),
        ],
      ),
    );
  }
}
