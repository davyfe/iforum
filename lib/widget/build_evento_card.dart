import 'package:flutter/material.dart';
import '/widget/build_chip.dart';
import '/widget/build_divider_pontilhado.dart';
import '/widget/build_evento_detalhe.dart';
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
  Future<void> _alternarFavorito() async {
    await EventoDao().atualizarFavorito(
      widget.evento.id!,
      !widget.evento.favorito,
    );
    widget.onAlterado?.call();
  }

  void _abrirDetalhe() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BuildEventoDetalhe(
        evento: widget.evento,
        onAlterado: widget.onAlterado,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final evento = widget.evento;

    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: evento.cor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BuildText(
                  evento.data,
                  bold: true,
                  color: Colors.white,
                  size: 12,
                ),
                BuildText(
                  evento.horario,
                  bold: true,
                  color: Colors.white,
                  size: 12,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _abrirDetalhe,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildText(evento.titulo, bold: true, size: 16),
                      const SizedBox(height: 10),
                      const BuildDividerPontilhado(cor: Colors.black26),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 20,
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
                      const SizedBox(height: 5),
                      const BuildDividerPontilhado(cor: Colors.black26),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 20,
                            color: Cores.textoTerciario,
                          ),
                          const SizedBox(width: 4),
                          BuildText(
                            evento.autor,
                            color: Cores.textoTerciario,
                            size: 13,
                          ),
                          const Spacer(),
                          InkWell(
                            customBorder: const CircleBorder(),
                            onTap: evento.id != null ? _alternarFavorito : null,
                            child: Icon(
                              evento.favorito
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 25,
                              color: evento.favorito
                                  ? Colors.redAccent
                                  : Cores.textoTerciario,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
