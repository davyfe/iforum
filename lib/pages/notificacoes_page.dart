import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/db/notificacao_dao.dart';
import '/api/evento_api.dart';
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

  Future<void> _gerarNotificacoesDeEventos() async {
    final eventos = await EventosApi().listarEventos();
    final existentes = await NotificacaoDao().listarNotificacoes();
    final hoje = DateTime.now();

    for (var evento in eventos) {
      if (!evento.inscrito) continue;

      final p = evento.data.split('/');
      if (p.length != 3) continue;
      final dias = DateTime(
        int.parse(p[2]),
        int.parse(p[1]),
        int.parse(p[0]),
      ).difference(hoje).inDays;
      if (dias < 0 || dias > 3) continue;
      if (existentes.any(
        (n) => n.tipo == 'evento' && n.titulo.contains(evento.titulo),
      ))
        continue;

      await NotificacaoDao().inserirNotificacao(
        Notificacao(
          titulo: 'Evento em breve: ${evento.titulo}',
          mensagem:
              'Acontece em ${evento.data} às ${evento.horario}, em ${evento.local}.',
          tipo: 'evento',
          data:
              '${hoje.day.toString().padLeft(2, '0')}/${hoje.month.toString().padLeft(2, '0')}/${hoje.year}',
        ),
      );
    }
  }

  void recarregar() => setState(() => futureNotificacoes = _carregar());

  Future<void> _marcarComoLida(Notificacao n) async {
    if (n.lida) return;
    await NotificacaoDao().marcarComoLida(n.id!);
    recarregar();
  }

  IconData _icone(String tipo) {
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
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          final lista = snapshot.data ?? [];
          if (lista.isEmpty)
            return Center(
              child: BuildText(
                'Nenhuma notificação por aqui',
                color: Cores.textoTerciario,
              ),
            );
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: lista.length,
            separatorBuilder: (context, i) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final n = lista[i];
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _marcarComoLida(n),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: n.lida
                        ? Colors.white
                        : Cores.verde.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(_icone(n.tipo), color: Cores.verde),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BuildText(n.titulo, bold: true, size: 14),
                            BuildText(
                              n.mensagem,
                              size: 13,
                              color: Cores.textoTerciario,
                            ),
                            BuildText(
                              n.data,
                              size: 11,
                              color: Cores.textoTerciario,
                            ),
                          ],
                        ),
                      ),
                      if (!n.lida)
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
