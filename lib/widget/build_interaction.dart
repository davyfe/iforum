import 'package:flutter/material.dart';
import 'package:iforum/widget/build_text.dart';

class BuildInteractionBar extends StatefulWidget {
  final int likes;
  final int comentarios;
  final Widget trailing;

  const BuildInteractionBar({
    super.key,
    required this.likes,
    required this.comentarios,
    required this.trailing,
  });

  @override
  State<BuildInteractionBar> createState() => _BuildInteractionBarState();
}

class _BuildInteractionBarState extends State<BuildInteractionBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildChip(
          Row(
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
        const SizedBox(width: 8),
        _buildChip(
          Row(
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
        const Spacer(),
        _buildChip(widget.trailing),
      ],
    );
  }

  Widget _buildChip(Widget conteudo) {
    return RawChip(
      label: conteudo,
      side: const BorderSide(color: Colors.black26, width: 0.5),
      shape: const StadiumBorder(),
      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      showCheckmark: false,
      onPressed: null,
    );
  }
}
