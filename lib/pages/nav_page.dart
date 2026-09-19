import 'package:flutter/material.dart';
import 'package:iforum/widget/build_comentario.dart';
import 'package:iforum/widget/build_text.dart';
import '/domain/noticia.dart';
import '/domain/comentario.dart';
import '/db/comentario_dao.dart';
import '/db/shared_prefs.dart';

class NavPage extends StatefulWidget {
  final Noticia noticia;

  const NavPage({super.key, required this.noticia});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  final _comentarioController = TextEditingController();
  late Future<List<Comentario>> _futureComentarios;

  @override
  void initState() {
    super.initState();
    _futureComentarios = ComentarioDao().listarPorNoticia(
      widget.noticia.titulo,
    );
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _comentar() async {
    final texto = _comentarioController.text.trim();
    if (texto.isEmpty) return;
    final autor = await SharedPrefs().getUsername() ?? 'anonimo';
    await ComentarioDao().inserirComentario(
      Comentario(
        noticiaTitulo: widget.noticia.titulo,
        autor: autor,
        texto: texto,
        tempo: 'agora mesmo',
      ),
    );
    _comentarioController.clear();
    setState(
      () => _futureComentarios = ComentarioDao().listarPorNoticia(
        widget.noticia.titulo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            pinned: true,
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.noticia.urlImagem,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const SizedBox.shrink(),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                        stops: [0.3, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 20,
                    right: 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.noticia.titulo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Por ${widget.noticia.autor}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Publicado em ${widget.noticia.data}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black38,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.noticia.texto,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 30),
                  FutureBuilder<List<Comentario>>(
                    future: _futureComentarios,
                    builder: (context, snapshot) {
                      final lista = snapshot.data ?? [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuildText(
                            'Comentários (${lista.length})',
                            bold: true,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _comentarioController,
                                  decoration: const InputDecoration(
                                    hintText: 'Escreva um comentário...',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _comentar,
                                icon: const Icon(Icons.send),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...lista.map(
                            (c) => BuildComentario(
                              texto: c.texto,
                              autor: c.autor,
                              tempo: c.tempo,
                              likes: c.likes,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
