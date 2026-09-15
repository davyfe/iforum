import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/widget/build_evento_card.dart';
import '/api/eventos_api.dart';
import '/db/evento_dao.dart';
import '/domain/evento.dart';
import '/cores.dart';

class Eventos extends StatefulWidget {
  const Eventos({super.key});

  @override
  State<StatefulWidget> createState() => _EventosState();
}

class _EventosState extends State<Eventos> {
  late Future<List<Evento>> futureListEventos;
  final _pesquisaController = TextEditingController();

  String aba = 'programacao';
  String termoPesquisa = '';
  bool filtrarFavoritos = false;

  @override
  void initState() {
    super.initState();
    futureListEventos = _carregarEventos();
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  Future<List<Evento>> _carregarEventos() async {
    final eventosSalvos = await EventosApi().listarEventos();
    return eventosSalvos;
  }

  void recarregar() {
    setState(() {
      futureListEventos = _carregarEventos();
    });
  }

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

    if (filtrarFavoritos) {
      lista = lista.where((e) => e.favorito).toList();
    }

    return lista;
  }

  void _abrirFiltro() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: BuildText('Filtrar eventos', bold: true, size: 18),
            content: CheckboxListTile(
              value: filtrarFavoritos,
              onChanged: (valor) {
                setStateDialog(() => filtrarFavoritos = valor ?? false);
              },
              title: BuildText('Somente favoritos'),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Cores.verde,
              contentPadding: EdgeInsets.zero,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: BuildText('Aplicar', color: Cores.verde, bold: true),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Cores.verde,
        title: BuildText('Eventos', bold: true, color: Colors.white, size: 20),
        centerTitle: true,
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
          _buildBarraPesquisa(),
          Expanded(
            child: FutureBuilder(
              future: futureListEventos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final lista = _aplicarFiltros(snapshot.requireData);
                  if (lista.isEmpty) {
                    return Center(
                      child: BuildText(
                        'Nenhum evento encontrado',
                        color: Cores.textoTerciario,
                      ),
                    );
                  }
                  return buildListView(lista);
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.grey,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        BuildText(
                          'Erro ao carregar eventos',
                          color: Colors.red,
                        ),
                        BuildText(snapshot.error.toString(), color: Colors.red),
                      ],
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbas() {
    final abas = {'programacao': 'Programação', 'agenda': 'Minha Agenda'};

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

  Widget _buildBarraPesquisa() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: _abrirFiltro,
            icon: Icon(
              Icons.filter_list,
              color: filtrarFavoritos ? Cores.verde : Cores.textoTerciario,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _pesquisaController,
              onChanged: (valor) => setState(() => termoPesquisa = valor),
              decoration: InputDecoration(
                hintText: 'Pesquisar eventos...',
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

  ListView buildListView(List<Evento> listaEventos) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: listaEventos.length,
      itemBuilder: (context, i) =>
          BuildEventoCard(evento: listaEventos[i], onAlterado: recarregar),
    );
  }
}
