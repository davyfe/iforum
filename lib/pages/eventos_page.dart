import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/widget/build_cardEvento.dart';
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

  @override
  void initState() {
    super.initState();
    futureListEventos = EventoDao().listarEventos();
  }

  void recarregar() {
    setState(() {
      futureListEventos = EventoDao().listarEventos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          IconButton(icon: const Icon(Icons.search_outlined), onPressed: () {}),
        ],
      ),
      body: FutureBuilder(
        future: futureListEventos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Evento> listaEventos = snapshot.requireData;
            return buildListView(listaEventos);
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.grey, size: 48),
                  const SizedBox(height: 8),
                  BuildText('Erro ao carregar eventos', color: Colors.red),
                  BuildText(snapshot.error.toString(), color: Colors.red),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  ListView buildListView(listaEventos) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: listaEventos.length,
      itemBuilder: (context, i) => BuildCardEvento(evento: listaEventos[i]),
    );
  }
}