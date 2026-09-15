import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/widget/build_post.dart';
import 'pesquisar_page.dart';
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

  @override
  void initState() {
    super.initState();
    futureListaPosts = PostsApi().listarPosts();
  }

  void recarregar() {
    setState(() {
      futureListaPosts = PostsApi().listarPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _buildLeading(),
        title: _buildTitle(),
        actions: [_buildAction()],
        backgroundColor: Cores.verde,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: futureListaPosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Post> listaPosts = snapshot.requireData;
            return buildListView(listaPosts);
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

  ListView buildListView(listaPosts) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: listaPosts.length,
      itemBuilder: (context, i) => BuildPost(post: listaPosts[i]),
    );
  }

  Widget _buildLeading() {
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

  Widget _buildTitle() {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const pesquisar_page()));
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Theme.of(context).colorScheme.onPrimary),
            const SizedBox(width: 8),
            BuildText(
              'Pesquisar',
              color: Theme.of(context).colorScheme.onPrimary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAction() {
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
}
