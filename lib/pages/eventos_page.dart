import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/widget/build_evento_card.dart';
import '/widget/build_search_bar.dart';
import '/widget/build_estado.dart';
import '/widget/build_filtro_dialog.dart';
import '/api/evento_api.dart';
import '/db/shared_prefs.dart';
import '/domain/evento.dart';
import '/cores.dart';

class Eventos extends StatefulWidget {
  const Eventos({super.key});

  @override
  State<Eventos> createState() => _EventosState();
}

class _EventosState extends State<Eventos> {
  late Future<List<Evento>> futureListaEventos;
  final _pesquisaController = TextEditingController();

  String aba = 'programacao';
  String termoPesquisa = '';
  bool filtrarFavoritos = false;

  @override
  void initState() {
    super.initState();
    futureListaEventos = _carregar();
  }

  Future<List<Evento>> _carregar() async {
    final eventos = await EventosApi().listarEventos();
    final favoritos = await SharedPrefs().eventosFavoritos();
    final inscritos = await SharedPrefs().eventosInscritos();
    for (var evento in eventos) {
      evento.favorito = favoritos.contains(evento.id);
      evento.inscrito = inscritos.contains(evento.id);
    }
    return eventos;
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  void recarregar() => setState(() => futureListaEventos = _carregar());

  List<Evento> _aplicarFiltros(List<Evento> eventos) {
    var lista = eventos
        .where((e) => aba == 'agenda' ? e.inscrito : !e.inscrito)
        .toList();
    if (termoPesquisa.isNotEmpty) {
      lista = lista
          .where(
            (e) => e.titulo.toLowerCase().contains(termoPesquisa.toLowerCase()),
          )
          .toList();
    }
    if (filtrarFavoritos) lista = lista.where((e) => e.favorito).toList();
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        title: BuildText('Eventos', bold: true, size: 20),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: recarregar,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildAbas(),
          BuildSearchBar(
            controller: _pesquisaController,
            hint: 'Pesquisar eventos...',
            onChanged: (valor) => setState(() => termoPesquisa = valor),
            filtroAtivo: filtrarFavoritos,
            onFiltro: () async {
              final valor = await mostrarFiltro<bool>(
                context,
                titulo: 'Filtrar eventos',
                opcoes: const [
                  OpcaoFiltro(false, 'Todos'),
                  OpcaoFiltro(true, 'Somente favoritos'),
                ],
                valorAtual: filtrarFavoritos,
              );
              if (valor != null) setState(() => filtrarFavoritos = valor);
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: futureListaEventos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const BuildEstado(
                    icone: Icons.error_outline,
                    mensagem: 'Erro ao carregar eventos',
                  );
                }
                final lista = _aplicarFiltros(snapshot.data ?? []);
                if (lista.isEmpty) {
                  return const BuildEstado(
                    icone: Icons.event_busy_outlined,
                    mensagem: 'Nenhum evento encontrado',
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: lista.length,
                  itemBuilder: (context, i) => BuildEventoCard(
                    evento: lista[i],
                    onAlterado: () => setState(() {}),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbas() {
    const abas = {'programacao': 'Programação', 'agenda': 'Minha Agenda'};
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: abas.entries.map((entry) {
          final selecionado = aba == entry.key;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => setState(() => aba = entry.key),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selecionado ? Cores.verde : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: BuildText(
                    entry.value,
                    bold: true,
                    color: selecionado ? Colors.white : Cores.textoTerciario,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
