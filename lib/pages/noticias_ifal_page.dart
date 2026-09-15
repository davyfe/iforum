import 'package:flutter/material.dart';
import '/api/noticia_ifal_api.dart';
import '/domain/noticia_ifal.dart';
import '/widget/build_noticia_ifal.dart';
import '/widget/build_text.dart';
import '/cores.dart';

class NoticiasIfal extends StatefulWidget {
  const NoticiasIfal({super.key});

  @override
  State<NoticiasIfal> createState() => _NoticiasIfalState();
}

class _NoticiasIfalState extends State<NoticiasIfal> {
  late Future<List<NoticiaIfal>> futureListaNoticiasIfal;

  @override
  void initState() {
    super.initState();
    futureListaNoticiasIfal = NoticiaIfalApi().listarNoticiasIfal();
  }

  void recarregar() {
    setState(() {
      futureListaNoticiasIfal = NoticiaIfalApi().listarNoticiasIfal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Cores.verde,
        title: BuildText('Notícias Gerais do IFAL', bold: true, color: Colors.white, size: 20),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh_outlined), onPressed: recarregar),
        ],
      ),
      body: FutureBuilder(
        future: futureListaNoticiasIfal,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<NoticiaIfal> lista = snapshot.requireData;
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: lista.length,
              itemBuilder: (context, i) => BuildNoticiaIfal(noticia: lista[i]),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.grey, size: 48),
                  const SizedBox(height: 8),
                  BuildText('Erro ao carregar as notícias do IFAL', color: Colors.red),
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
}