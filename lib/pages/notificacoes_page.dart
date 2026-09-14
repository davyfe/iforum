import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/db/notificacao_dao.dart';
import '/db/evento_dao.dart';
import '/domain/notificacao.dart';
import '/cores.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  late Future<List<Notificacao>> futureNotificacoes;

  @override
  void initState() {
    super.initState();
    futureNotificacoes = _carregar();
  }

  Future<List<Notificacao>> _carregar() async {
    await _gerarNotificacoesDeEventos();
    return NotificacaoDao().listarNotificacoes();
  }

  // gera notificações para eventos inscritos que acontecem nos próximos 3 dias
  Future<void> _gerarNotificacoesDeEventos() async {
    final eventos = await EventoDao().listarEventos();
    final existentes = await NotificacaoDao().listarNotificacoes();
    final hoje = DateTime.now();

    for (var evento in eventos) {
      if (!evento.inscrito) continue;

      final dataEvento = _parseData(evento.data);
      if (dataEvento == null) continue;

      final diasRestantes = dataEvento.difference(hoje).inDays;
      if (diasRestantes < 0 || diasRestantes > 3) continue;

      final jaNotificado = existentes.any(
        (n) => n.tipo == 'evento' && n.titulo.contains(evento.titulo),
      );
      if (jaNotificado) continue;

      await NotificacaoDao().inserirNotificacao(
        Notificacao(
          titulo: 'Evento em breve: ${evento.titulo}',
          mensagem:
              'Acontece em ${evento.data} às ${evento.horario}, em ${evento.local}.',
          tipo: 'evento',
          data: _formatarData(hoje),
        ),
      );
    }
  }

  DateTime? _parseData(String data) {
    try {
      final partes = data.split('/');
      return DateTime(
        int.parse(partes[2]),
        int.parse(partes[1]),
        int.parse(partes[0]),
      );
    } catch (_) {
      return null;
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  void recarregar() => setState(() => futureNotificacoes = _carregar());

  IconData _iconePorTipo(String tipo) {
    switch (tipo) {
      case 'evento':
        return Icons.event;
      case 'emprestimo':
        return Icons.menu_book;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Cores.verde,
        title: BuildText(
          'Notificações',
          bold: true,
          color: Colors.white,
          size: 20,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: recarregar,
          ),
        ],
      ),
      body: FutureBuilder<List<Notificacao>>(
        future: futureNotificacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final lista = snapshot.data ?? [];
          if (lista.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 48,
                    color: Cores.textoTerciario,
                  ),
                  const SizedBox(height: 8),
                  BuildText(
                    'Nenhuma notificação por aqui',
                    color: Cores.textoTerciario,
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: lista.length,
            separatorBuilder: (context, i) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final notificacao = lista[i];
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  if (!notificacao.lida) {
                    await NotificacaoDao().marcarComoLida(notificacao.id!);
                    recarregar();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: notificacao.lida
                        ? Colors.white
                        : Cores.verde.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Cores.verde.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _iconePorTipo(notificacao.tipo),
                          color: Cores.verde,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BuildText(notificacao.titulo, bold: true, size: 14),
                            const SizedBox(height: 4),
                            BuildText(
                              notificacao.mensagem,
                              size: 13,
                              color: Cores.textoTerciario,
                            ),
                            const SizedBox(height: 4),
                            BuildText(
                              notificacao.data,
                              size: 11,
                              color: Cores.textoTerciario,
                            ),
                          ],
                        ),
                      ),
                      if (!notificacao.lida)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
