import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/widget/build_estado.dart';
import '/db/notificacao_dao.dart';
import '/api/evento_api.dart';
import '/api/emprestimo_api.dart';
import '/db/shared_prefs.dart';
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
    await _gerarNotificacoes();
    return NotificacaoDao().listarNotificacoes();
  }

  Future<void> _gerarNotificacoes() async {
    final hoje = DateTime.now();
    final existentes = await NotificacaoDao().listarNotificacoes();

    final inscritos = await SharedPrefs().eventosInscritos();
    final eventos = await EventosApi().listarEventos();
    for (var evento in eventos.where((e) => inscritos.contains(e.id))) {
      final data = _parseData(evento.data);
      if (data == null) continue;
      final dias = data.difference(hoje).inDays;
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
          data: _formatarData(hoje),
        ),
      );
    }

    final emprestimos = await EmprestimoApi().listarAtuais();
    for (var emprestimo in emprestimos) {
      final prevista = _parseData(emprestimo.dataPrevista);
      if (prevista == null) continue;
      final dias = prevista.difference(hoje).inDays;
      if (dias < 0 || dias > 2) continue;
      if (existentes.any(
        (n) =>
            n.tipo == 'emprestimo' && n.titulo.contains(emprestimo.tituloLivro),
      ))
        continue;
      await NotificacaoDao().inserirNotificacao(
        Notificacao(
          titulo: 'Devolução próxima: ${emprestimo.tituloLivro}',
          mensagem: 'Prazo de devolução em ${emprestimo.dataPrevista}.',
          tipo: 'emprestimo',
          data: _formatarData(hoje),
        ),
      );
    }
  }

  DateTime? _parseData(String data) {
    try {
      final p = data.split('/');
      return DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
    } catch (_) {
      return null;
    }
  }

  String _formatarData(DateTime data) =>
      '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

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
        title: BuildText('Notificações', bold: true, size: 20),
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
            return const BuildEstado(
              icone: Icons.notifications_none,
              mensagem: 'Nenhuma notificação por aqui',
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
                        : Cores.verde.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
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
                          color: Cores.verde.withValues(alpha: 0.15),
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
