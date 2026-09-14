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
  String filtroAtual =
      'todos'; // 'todos', 'inscritos', 'naoInscritos' ou 'favoritos'

  @override
  void initState() {
    super.initState();
    futureListEventos = _carregarEventos();
  }

  Future<List<Evento>> _carregarEventos() async {
    final eventosSalvos = await EventoDao().listarEventos();
    if (eventosSalvos.isEmpty) {
      final eventosApi = await EventosApi().listarEventos();
      for (var evento in eventosApi) {
        await EventoDao().inserirEvento(evento);
      }
      return EventoDao().listarEventos();
    }
    return eventosSalvos;
  }

  void recarregar() {
    setState(() {
      futureListEventos = _carregarEventos();
    });
  }

  List<Evento> _aplicarFiltro(List<Evento> eventos) {
    switch (filtroAtual) {
      case 'inscritos':
        return eventos.where((e) => e.inscrito).toList();
      case 'naoInscritos':
        return eventos.where((e) => !e.inscrito).toList();
      case 'favoritos':
        return eventos.where((e) => e.favorito).toList();
      default:
        return eventos;
    }
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
          _buildFiltros(),
          Expanded(
            child: FutureBuilder(
              future: futureListEventos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final lista = _aplicarFiltro(snapshot.requireData);
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

  Widget _buildFiltros() {
    final filtros = {
      'todos': 'Todos',
      'inscritos': 'Inscritos',
      'naoInscritos': 'Não inscritos',
      'favoritos': 'Favoritos',
    };

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: filtros.entries.map((entry) {
          final selecionado = filtroAtual == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: selecionado,
              selectedColor: Cores.verde,
              labelStyle: TextStyle(
                color: selecionado ? Colors.white : Colors.black87,
              ),
              onSelected: (_) => setState(() => filtroAtual = entry.key),
            ),
          );
        }).toList(),
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
