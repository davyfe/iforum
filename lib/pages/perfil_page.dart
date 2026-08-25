import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/cores.dart';

import '/db/post_dao.dart';
import '/domain/post.dart';
import '/widget/build_post.dart';

// nota: atualmente, no banco de dados de usuário
// só tem username e senha, o resto coloco manualmente.
// p/ depois: editar perfil e adocionar outros atributos no banco.

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> with SingleTickerProviderStateMixin {
  final usuario = 'pdrolopes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Cores.verde,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings_outlined)),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        children: [
          _buildHeader(username: usuario),
          _buildTab(),
          _buildPostsTab(autor: usuario),
        ],
      ),
    );
  }

  Widget _buildHeader({required String username}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 25, right: 25, bottom: 20, top: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black, Cores.verde],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 45, backgroundColor: Colors.white),
          const SizedBox(height: 10),
          BuildText(username, size: 30, bold: true, color: Colors.white),
          BuildText(username, size: 20, color: Colors.white),
          const SizedBox(height: 4),
          Row(
            children: [
              BuildText('6', size: 15, bold: true, color: Colors.white),
              const SizedBox(width: 5),
              BuildText('seguidores', size: 15, color: Colors.white),
              const SizedBox(width: 5),
              BuildText('10', size: 15, bold: true, color: Colors.white),
              const SizedBox(width: 5),
              BuildText('seguindo', size: 15, color: Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          BuildText(
            '\'Não esquecer que por enquanto é tempo de morangos. Sim.\' - Clarice Lispector, A Hora da Estrela.',
            size: 15,
            color: Colors.white,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.school, size: 18, color: Colors.white),
              const SizedBox(width: 5),
              BuildText(
                'Técnico em Informática',
                size: 15,
                color: Colors.white,
              ),
              const SizedBox(width: 15),
              const Icon(Icons.location_city, color: Colors.white, size: 18),
              const SizedBox(width: 5),
              BuildText('Campus Arapiraca', size: 15, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab() {
    return DefaultTabController(
      length: 1,
      child: Column(
        children: [
          Container(
            child: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorColor: Cores.verde,
              indicatorWeight: 3.0,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [Tab(text: "Posts")],
            ),
          ),
          Expanded(
            child: TabBarView(children: [_buildPostsTab(autor: usuario)]),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab({required String autor}) {
    return FutureBuilder<List<Post>>(
      future: PostDao().listarPorAutor(autor),
      builder: (context, snapshot) {
        // verifica possiveis acontecimentos durante o carregamento dos posts
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
              ],
            ),
          );
        }

        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  const TextSpan(text: 'Você não possui nenhum post.'),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: posts.length,
          itemBuilder: (context, i) => BuildPost(post: posts[i]),
        );
      },
    );
  }
}
