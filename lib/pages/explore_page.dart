import 'package:flutter/material.dart';
import '/widget/build_post.dart';
import '/widget/build_search_bar.dart';
import '/widget/build_estado.dart';
import '/widget/build_filtro_dialog.dart';
import 'notificacoes_page.dart';
import '/api/post_api.dart';
import '/db/shared_prefs.dart';
import '/domain/post.dart';
import 'criar_page.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late Future<List<Post>> futureListaPosts;
  final _pesquisaController = TextEditingController();

  String termoPesquisa = '';
  bool filtrarFavoritos = false;

  @override
  void initState() {
    super.initState();
    futureListaPosts = _carregar();
  }

  Future<List<Post>> _carregar() async {
    final posts = await PostsApi().listarPosts();
    final favoritos = await SharedPrefs().postsFavoritos();
    for (var post in posts) {
      post.favorito = favoritos.contains(post.id);
    }
    return posts;
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  void recarregar() => setState(() => futureListaPosts = _carregar());

  List<Post> _aplicarFiltros(List<Post> posts) {
    var lista = posts;
    if (termoPesquisa.isNotEmpty) {
      lista = lista
          .where(
            (e) => e.titulo.toLowerCase().contains(termoPesquisa.toLowerCase()),
          )
          .toList();
    }
    if (filtrarFavoritos) lista = lista.where((e) => e.favorito).toList();
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NotificacoesPage()),
          ),
          icon: const Icon(Icons.notifications),
        ),
        title: BuildSearchBar(
          controller: _pesquisaController,
          hint: 'Pesquisar posts...',
          onChanged: (valor) => setState(() => termoPesquisa = valor),
          filtroAtivo: filtrarFavoritos,
          onFiltro: () async {
            final valor = await mostrarFiltro<bool>(
              context,
              titulo: 'Filtrar posts',
              opcoes: const [
                OpcaoFiltro(false, 'Todos'),
                OpcaoFiltro(true, 'Somente favoritos'),
              ],
              valorAtual: filtrarFavoritos,
            );
            if (valor != null) setState(() => filtrarFavoritos = valor);
          },
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
      ),
      body: FutureBuilder(
        future: futureListaPosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const BuildEstado(
              icone: Icons.error_outline,
              mensagem: 'Erro ao carregar posts',
            );
          }
          final lista = _aplicarFiltros(snapshot.data ?? []);
          if (lista.isEmpty) {
            return const BuildEstado(
              icone: Icons.forum_outlined,
              mensagem: 'Nenhum post encontrado',
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
