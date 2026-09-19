import 'package:flutter/material.dart';
import '/cores.dart';

class BuildSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onFiltro;
  final bool filtroAtivo;

  const BuildSearchBar({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onFiltro,
    this.filtroAtivo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onFiltro,
            icon: Icon(
              Icons.filter_list,
              color: filtroAtivo ? Cores.verde : Cores.textoTerciario,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
