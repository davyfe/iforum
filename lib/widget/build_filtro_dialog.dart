import 'package:flutter/material.dart';
import 'build_text.dart';
import '/cores.dart';

class OpcaoFiltro<T> {
  final T valor;
  final String rotulo;
  const OpcaoFiltro(this.valor, this.rotulo);
}

Future<T?> mostrarFiltro<T>(
  BuildContext context, {
  required String titulo,
  required List<OpcaoFiltro<T>> opcoes,
  required T valorAtual,
}) {
  T selecionado = valorAtual;
  return showDialog<T>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setStateDialog) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: BuildText(titulo, bold: true, size: 18),
        content: RadioGroup<T>(
          groupValue: selecionado,
          onChanged: (valor) => setStateDialog(() => selecionado = valor as T),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: opcoes
                .map(
                  (o) => RadioListTile<T>(
                    value: o.valor,
                    title: BuildText(o.rotulo),
                    activeColor: Cores.verde,
                    contentPadding: EdgeInsets.zero,
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(selecionado),
            child: BuildText('Aplicar', color: Cores.verde, bold: true),
          ),
        ],
      ),
    ),
  );
}
