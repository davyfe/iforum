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
  bool filtrarFavoritos = false;
  // ainda nao tem a logica pra funcionar

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

  List<Post> _aplicarFiltros(List<Post> posts) {
    var lista = posts;

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
            title: BuildText('Filtrar posts', bold: true, size: 18),
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
      appBar: AppBar(
        leading: _buildLeading(),
        title: _buildBarraPesquisa(),
        actions: [_buildAction()],
        backgroundColor: Cores.verde,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: futureListaPosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final lista = _aplicarFiltros(snapshot.requireData);
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
          ),
        ],
      ),
    );
  }

  Builder _buildLeading() {
    return Builder(
      builder: (BuildContext context) => IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NotificacoesPage()),
          );
        },
        icon: const Icon(Icons.notifications),
      ),
    );
  }

  IconButton _buildAction() {
    return IconButton(
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
      icon: const Icon(Icons.add),
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