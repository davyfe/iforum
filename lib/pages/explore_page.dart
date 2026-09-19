import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/widget/build_post.dart';
import '/widget/build_search_bar.dart';
import 'notificacoes_page.dart';
import '/db/post_dao.dart';
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

  @override
  void initState() {
    super.initState();
    futureListaPosts = PostDao().listarPosts();
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  void recarregar() {
    setState(() => futureListaPosts = PostDao().listarPosts());
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
              onChanged: (valor) =>
                  setStateDialog(() => filtrarFavoritos = valor ?? false),
              title: BuildText('Somente salvos'),
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
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NotificacoesPage()),
            ),
            icon: const Icon(Icons.notifications),
          ),
        ),
        title: BuildSearchBar(
          controller: _pesquisaController,
          hint: 'Pesquisar posts...',
          onChanged: (valor) => setState(() => termoPesquisa = valor),
          onFiltro: _abrirFiltro,
          filtroAtivo: filtrarFavoritos,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final criou = await Navigator.of(context, rootNavigator: true)
                  .push<bool>(
                    MaterialPageRoute(
                      builder: (context) => const CriarPost(),
                      fullscreenDialog: true,
                    ),
                  );
              if (criou == true) recarregar();
            },
            icon: const Icon(Icons.add),
          ),
        ],
        backgroundColor: Cores.verde,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: futureListaPosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: BuildText('Erro ao carregar posts', color: Colors.red),
            );
          }
          final lista = _aplicarFiltros(snapshot.data ?? []);
          if (lista.isEmpty) {
            return Center(
              child: BuildText(
                'Nenhum post encontrado',
                color: Cores.textoTerciario,
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: lista.length,
            itemBuilder: (context, i) =>
                BuildPost(post: lista[i], onAlterado: recarregar),
          );
        },
      ),
    );
  }
}
