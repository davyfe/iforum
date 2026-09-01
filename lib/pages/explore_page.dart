import 'package:flutter/material.dart';
import 'package:iforum/widget/build_text.dart';
import '/db/post_dao.dart';
import '/domain/post.dart';
import '/widget/build_post.dart';
import '/cores.dart';
import 'criar_page.dart';

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
    futureListaPosts = PostDao().listarPosts();
  }

  void recarregar() {
    setState(() {
      futureListaPosts = PostDao().listarPosts();
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
      builder: (BuildContext context) =>
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
    );
  }

  Widget _buildTitle() {
    return SizedBox(
      height: 40,
      child: TextField(
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Pesquisar',
          hintStyle: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.7),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1.5,
            ),
          ),
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
