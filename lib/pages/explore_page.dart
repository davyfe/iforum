import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/widget/build_post.dart';
import 'notificacoes_page.dart';
import '/api/post_api.dart';
import '/domain/post.dart';
import 'criar_page.dart';
import '/cores.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<StatefulWidget> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late Future<List<Post>> futureListaPosts;
  final _pesquisaController = TextEditingController();
  String termoPesquisa = '';
  bool filtrar = false;

  @override
  void initState() {
    super.initState();
    futureListaPosts = PostsApi().listarPosts();
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  void recarregar() {
    setState(() {
      futureListaPosts = PostsApi().listarPosts();
    });
  }

  List<Post> _filtrar(List<Post> posts) {
    List<Post> lista = [];
    for (var e in posts) {
      if (termoPesquisa.isNotEmpty &&
          !e.titulo.toLowerCase().contains(termoPesquisa.toLowerCase())) {
        continue;
      }
      lista.add(e);
    }
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          iconTheme: IconThemeData(color: Cores.verde),
          backgroundColor: Cores.fundo,
          title: _buildBarraPesquisa(),
          leading: _buildLeading(),
          actions: [_buildAction()],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      body: FutureBuilder(
        future: futureListaPosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final lista = _filtrar(snapshot.requireData);
            if (lista.isEmpty) {
              return Center(
                child: BuildText(
                  'Nenhum post encontrado',
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
                  const Icon(Icons.error_outline, color: Colors.grey, size: 48),
                  const SizedBox(height: 8),
                  BuildText('Erro ao carregar posts', color: Colors.red),
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

  void _abrirFiltro() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: BuildText('Filtrar eventos', bold: true, size: 18),
        children: [
          CheckboxListTile(
            value: filtrar,
            onChanged: (v) {
              setState(() => filtrar = v ?? false);
              Navigator.of(context).pop();
            },
            title: BuildText('APENAS ESTÉTICO POR ENQUANTO'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }

  Widget _buildBarraPesquisa() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
      child: TextField(
        controller: _pesquisaController,
        onChanged: (valor) => setState(() => termoPesquisa = valor),
        decoration: InputDecoration(
          hintText: 'Pesquisar posts...',
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
    );
  }

  IconButton _buildLeading() {
    return IconButton(
      onPressed: _abrirFiltro,
      icon: Icon(
        Icons.filter_list,
        size: 30,
        color: filtrar ? Cores.verde : Cores.textoTerciario,
      ),
    );
  }

  Builder _buildAction() {
    return Builder(
      builder: (BuildContext context) => IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NotificacoesPage()),
          );
        },
        icon: const Icon(Icons.notifications, size: 30),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        final criou = await Navigator.of(context, rootNavigator: true)
            .push<bool>(
              MaterialPageRoute(
                builder: (context) => const CriarPost(),
                fullscreenDialog: true,
              ),
            );
        if (criou == true) {
          recarregar();
        }
      },
      backgroundColor: Cores.verde,
      shape: const CircleBorder(),
      elevation: 15,
      child: Icon(Icons.edit, color: Colors.white),
    );
  }

  ListView buildListView(listaPosts) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: listaPosts.length,
      itemBuilder: (context, i) => BuildPost(post: listaPosts[i]),
    );
  }
}
