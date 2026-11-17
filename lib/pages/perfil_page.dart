import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/widget/build_post.dart';
import '/db/post_dao.dart';
import '/domain/post.dart';
import '/cores.dart';
import '/locais.dart';
import 'map_page.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final usuario = 'pdrolopes';
  late final Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = PostDao().listarPorAutor(usuario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(username: usuario),
                _buildTabBar(),
                _buildPosts(),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings_outlined, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({required String username}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20, top: 70),
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
            '\'Não esquecer que por enquanto é tempo de morangos. Sim.\' Clarice Lispector, A Hora da Estrela.',
            size: 15,
            color: Colors.white,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 15),
          _buildChip(
            Icons.location_pin,
            'Campus Arapiraca',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MapPage(
                  location: Locais.campusArapiraca,
                  titulo: 'Campus Arapiraca',
                  descricao: 'IFAL - Campus Arapiraca',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String text, {VoidCallback? onTap}) {
    return ActionChip(
      avatar: Icon(icon, color: Colors.white),
      label: BuildText(text, color: Colors.white, size: 12),
      onPressed: onTap ?? () {},
      backgroundColor: Colors.black,
      elevation: 0,
      side: const BorderSide(color: Colors.white, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      padding: const EdgeInsets.only(right: 5),
      labelPadding: const EdgeInsets.only(left: 2, right: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildTabBar() {
    return DefaultTabController(
      length: 1,
      child: TabBar(
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.black,
        indicatorColor: Cores.verde,
        indicatorWeight: 3.0,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [Tab(text: 'Posts')],
      ),
    );
  }

  Widget _buildPosts() {
    return FutureBuilder<List<Post>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: BuildText('Erro ao carregar posts', color: Colors.red),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final posts = snapshot.requireData;
        if (posts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: BuildText('Nenhum post ainda', color: Cores.textoTerciario),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: posts.length,
          itemBuilder: (context, i) => BuildPost(post: posts[i]),
        );
      },
    );
  }
}