import 'package:flutter/material.dart';

class BuildChip extends StatefulWidget {
  final Widget conteudo;

  const BuildChip({
    super.key,
    required this.conteudo,
  });

  @override
  State<BuildChip> createState() => _BuildChipState();
}

class _BuildChipState extends State<BuildChip> {
  @override
  Widget build(BuildContext context) {
    return RawChip(
      label: widget.conteudo,
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