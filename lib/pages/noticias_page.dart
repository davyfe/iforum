import 'package:flutter/material.dart';
import '/widget/build_noticia.dart';
import '/widget/build_text.dart';
import '/cores.dart';
import '/db/noticia_dao.dart';
import '/domain/noticia.dart';

class Noticias extends StatefulWidget {
  const Noticias({super.key});

  @override
  State<Noticias> createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  late Future<List<Noticia>> futureListaNoticias;

  @override
  void initState() {
    super.initState();
    futureListaNoticias = NoticiaDao().listarNoticias();
  }

  void recarregar() {
    setState(() async {
      futureListaNoticias = NoticiaDao().listarNoticias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Cores.verde,
        title: BuildText('Notícias', bold: true, color: Colors.white, size: 20),
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
        future: futureListaNoticias,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Noticia> listaNoticias = snapshot.requireData;
            return buildListView(listaNoticias);
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.grey, size: 48),
                  const SizedBox(height: 8),
                  BuildText('Erro ao carregar as notícias', color: Colors.red),
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

  ListView buildListView(listaNoticias) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: listaNoticias.length,
      itemBuilder: (context, i) => BuildNoticia(noticia: listaNoticias[i]),
    );
  }
}
