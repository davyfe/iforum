import 'package:flutter/material.dart';
import '/domain/evento.dart';
import '/api/evento_api.dart';
import '/cores.dart';
import 'build_text.dart';

class BuildEventoDetalhe extends StatefulWidget {
  final Evento evento;
  final VoidCallback? onAlterado;

  const BuildEventoDetalhe({super.key, required this.evento, this.onAlterado});

  @override
  State<BuildEventoDetalhe> createState() => _BuildEventoDetalheState();
}

class _BuildEventoDetalheState extends State<BuildEventoDetalhe> {
  late bool _inscrito;
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _inscrito = widget.evento.inscrito;
  }

  Future<void> _alternarInscricao() async {
    setState(() => _carregando = true);

    final novoValor = !_inscrito;
    final sucesso = await EventosApi().atualizarInscricao(
      widget.evento.id!,
      novoValor,
    );

    if (sucesso) {
      widget.evento.inscrito = novoValor;
      setState(() {
        _inscrito = novoValor;
        _carregando = false;
      });
      widget.onAlterado?.call();
    } else {
      setState(() => _carregando = false);
      // opcional: mostrar um SnackBar avisando que falhou
    }
  }

  Future<void> _confirmarDesinscricao() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: BuildText('Cancelar inscrição', bold: true, size: 18),
        content: BuildText(
          'Tem certeza que deseja se desinscrever de "${widget.evento.titulo}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: BuildText('Voltar', color: Cores.textoTerciario),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: BuildText(
              'Desinscrever',
              color: Colors.redAccent,
              bold: true,
            ),
          ),
        ],
      ),
    );

    if (confirmou == true) {
      await _alternarInscricao();
    }
  }

  @override
  Widget build(BuildContext context) {
    final evento = widget.evento;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildText(evento.titulo, bold: true, size: 20),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.date_range, size: 18, color: Cores.textoTerciario),
              const SizedBox(width: 6),
              BuildText(evento.data, color: Cores.textoTerciario),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 18, color: Cores.textoTerciario),
              const SizedBox(width: 6),
              BuildText(evento.horario, color: Cores.textoTerciario),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Cores.textoTerciario,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: BuildText(evento.local, color: Cores.textoTerciario),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_outline, size: 18, color: Cores.textoTerciario),
              const SizedBox(width: 6),
              BuildText(evento.autor, color: Cores.textoTerciario),
            ],
          ),
          const SizedBox(height: 20),
          BuildText('Descrição em breve.', color: Cores.textoTerciario),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _carregando
                  ? null
                  : (_inscrito ? _confirmarDesinscricao : _alternarInscricao),
              style: ElevatedButton.styleFrom(
                backgroundColor: _inscrito ? Colors.white : widget.evento.cor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(
                  color: widget.evento.cor,
                  width: _inscrito ? 1.5 : 0,
                ),
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              child: _carregando
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _inscrito ? widget.evento.cor : Colors.white,
                      ),
                    )
                  : BuildText(
                      _inscrito ? 'Desinscrever-se' : 'Inscrever-se',
                      bold: true,
                      color: _inscrito ? widget.evento.cor : Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
