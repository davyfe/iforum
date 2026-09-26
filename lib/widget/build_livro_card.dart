import 'package:flutter/material.dart';
import '/domain/livro.dart';
import '/cores.dart';
import 'build_text.dart';
import 'build_livro_detalhe.dart';

class BuildLivroCard extends StatelessWidget {
  final Livro livro;

  const BuildLivroCard({super.key, required this.livro});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => BuildLivroDetalhe(livro: livro),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                color: Cores.avatar.withValues(alpha: 0.15),
                child: livro.capaUrl.isNotEmpty
                    ? Image.network(
                        livro.capaUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.menu_book,
                              size: 40,
                              color: Colors.grey,
                            ),
                      )
                    : const Icon(Icons.menu_book, size: 40, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 6),
          BuildText(
            livro.titulo,
            bold: true,
            size: 13,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          BuildText(
            livro.autor,
            size: 12,
            color: Cores.textoTerciario,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
