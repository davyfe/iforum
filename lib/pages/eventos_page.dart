import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/widget/build_evento_card.dart';
import '/api/evento_api.dart';
import '/domain/evento.dart';
import '/cores.dart';

class Eventos extends StatefulWidget {
  const Eventos({super.key});

  @override
  State<StatefulWidget> createState() => _EventosState();
}

class _EventosState extends State<Eventos> {
  late Future<List<Evento>> futureEventos;
  final _pesquisaController = TextEditingController();

  String aba = 'programacao';
  String termoPesquisa = '';
  bool filtrarFavoritos = false;

  @override
  void initState() {
    super.initState();
    futureEventos = EventosApi().listarEventos();
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  void recarregar() {
    setState(() {
      futureEventos = EventosApi().listarEventos();
    });
  }

  List<Evento> _filtrar(List<Evento> eventos) {
    List<Evento> lista = [];
    for (var e in eventos) {
      if (aba == 'agenda' && !e.inscrito) continue;
      if (aba != 'agenda' && e.inscrito) continue;
      if (termoPesquisa.isNotEmpty &&
          !e.titulo.toLowerCase().contains(termoPesquisa.toLowerCase())) {
        continue;
      }
      if (filtrarFavoritos && !e.favorito) continue;
      lista.add(e);
    }
    return lista;
  }

  void _abrirFiltro() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: BuildText('Filtrar eventos', bold: true, size: 18),
          content: CheckboxListTile(
            value: filtrarFavoritos,
            onChanged: (v) =>
                setStateDialog(() => filtrarFavoritos = v ?? false),
            title: BuildText('Somente favoritos'),
            controlAffinity: ListTileControlAffinity.leading,
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
      ),
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
            child: FutureBuilder<List<Evento>>(
              future: futureEventos,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: BuildText(
                      'Erro ao carregar eventos',
                      color: Colors.red,
                    ),
                  );
                }
                final lista = _filtrar(snapshot.data!);
                if (lista.isEmpty) {
                  return Center(
                    child: BuildText(
                      'Nenhum evento encontrado',
                      color: Cores.textoTerciario,
                    ),
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

  Container _buildAbas() {
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
}
