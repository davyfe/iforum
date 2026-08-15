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
  List<Post> listaPosts = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    listaPosts = await PostDao().listarPosts();
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
  }

  void recarregar() {
    setState(() async {
      listaPosts = await PostDao().listarPosts();
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
      body: ListView.builder(
        itemCount: listaPosts.length,
        itemBuilder: (context, i) {
          return BuildPost(post: listaPosts[i]);
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
