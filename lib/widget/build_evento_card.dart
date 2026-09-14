import 'package:flutter/material.dart';
import '/domain/evento.dart';
import '/db/evento_dao.dart';
import '/cores.dart';
import 'build_text.dart';

class BuildEventoCard extends StatefulWidget {
  final Evento evento;
  final VoidCallback? onAlterado;

  const BuildEventoCard({super.key, required this.evento, this.onAlterado});

  @override
  State<BuildEventoCard> createState() => _BuildEventoCardState();
}

class _BuildEventoCardState extends State<BuildEventoCard> {
  Future<void> _alternarInscricao() async {
    await EventoDao().atualizarInscricao(
      widget.evento.id!,
      !widget.evento.inscrito,
    );
    widget.onAlterado?.call();
  }

  Future<void> _alternarFavorito() async {
    await EventoDao().atualizarFavorito(
      widget.evento.id!,
      !widget.evento.favorito,
    );
    widget.onAlterado?.call();
  }

  @override
  Widget build(BuildContext context) {
    final evento = widget.evento;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: BuildText(evento.titulo, bold: true, size: 16),
                  ),
                  IconButton(
                    onPressed: evento.id != null ? _alternarFavorito : null,
                    icon: Icon(
                      evento.favorito ? Icons.favorite : Icons.favorite_border,
                      color: evento.favorito
                          ? Colors.redAccent
                          : Cores.textoTerciario,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.date_range, size: 16, color: Cores.textoTerciario),
                  const SizedBox(width: 4),
                  BuildText(evento.data, color: Cores.textoTerciario, size: 13),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Cores.textoTerciario,
                  ),
                  const SizedBox(width: 4),
                  BuildText(
                    evento.horario,
                    color: Cores.textoTerciario,
                    size: 13,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Cores.textoTerciario,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: BuildText(
                      evento.local,
                      color: Cores.textoTerciario,
                      size: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: evento.id != null ? _alternarInscricao : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: evento.inscrito
                        ? Colors.white
                        : Cores.verde,
                    side: BorderSide(
                      color: Cores.verde,
                      width: evento.inscrito ? 1.5 : 0,
                    ),
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: BuildText(
                    evento.inscrito ? 'Inscrito ✓' : 'Inscrever-se',
                    bold: true,
                    color: evento.inscrito ? Cores.verde : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
