import 'package:flutter/material.dart';
import '/db/postDao.dart';
import '/domain/post.dart';
import '/widget/buildPost.dart';
import 'criarPost.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<StatefulWidget> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late Future<List<Post>> listaPosts;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    listaPosts = PostDao().listarPosts();
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
  }

  void recarregar() {
    setState(() async {
      listaPosts = PostDao().listarPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _buildLeading(),
        title: _buildTitle(),
        actions: [_buildAction()],
      ),
      body: FutureBuilder<List<Post>>(
        future: listaPosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.grey, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Erro ao carregar posts',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    snapshot.error.toString(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }
          final posts = snapshot.data ?? [];
          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.article_outlined,
                    color: Colors.grey,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nenhum post ainda.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: posts.length,
            itemBuilder: (context, i) => BuildPost(post: posts[i]),
          );
        },
      ),
    );
  }

  Widget _buildLeading() {
    return Builder(
      builder: (BuildContext context) => IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: const Icon(Icons.menu),
      ),
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
