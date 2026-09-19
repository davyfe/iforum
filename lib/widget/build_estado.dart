import 'package:flutter/material.dart';
import 'build_text.dart';
import '/cores.dart';

class BuildEstado extends StatelessWidget {
  final IconData icone;
  final String mensagem;

  const BuildEstado({super.key, required this.icone, required this.mensagem});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 48, color: Cores.textoTerciario),
          const SizedBox(height: 8),
          BuildText(mensagem, color: Cores.textoTerciario),
        ],
      ),
    );
  }
}
