import 'package:flutter/material.dart';
import 'build_text.dart';
import 'build_chip.dart';

class BuildInteractionBar extends StatefulWidget {
  final int likes;
  final int? comentarios;
  final String? reacao;

  const BuildInteractionBar({
    super.key,
    required this.likes,
    this.comentarios,
    this.reacao,
  });

  @override
  State<BuildInteractionBar> createState() => _BuildInteractionBarState();
}

class _BuildInteractionBarState extends State<BuildInteractionBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BuildChip(
          conteudo: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.thumb_up_alt_outlined,
                size: 16,
                color: Colors.black54,
              ),
              const SizedBox(width: 6),
              BuildText("${widget.likes} |", color: Colors.black54),
              const SizedBox(width: 8),
              const Icon(
                Icons.thumb_down_alt_outlined,
                size: 16,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        if (widget.comentarios != null) ...[
          const SizedBox(width: 8),
          BuildChip(
            conteudo: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 16,
                  color: Colors.black54,
                ),
                const SizedBox(width: 6),
                BuildText("${widget.comentarios}", color: Colors.black54),
              ],
            ),
          ),
        ],
        const Spacer(),
        BuildChip(
          conteudo: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.share_outlined, size: 20, color: Colors.black54),
            ],
          ),
        ),
        if (widget.reacao != null && widget.reacao!.isNotEmpty) ...[
          BuildChip(
            conteudo: Row(
              mainAxisSize: MainAxisSize.min,
              children: [BuildText(widget.reacao!)],
            ),
          ),
        ],
      ],
    );
  }
}
