import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widget/build_text.dart';
import '../cores.dart';
import '../db/post_dao.dart';
import '../widget/build_post.dart';
import 'mapa_campus_page.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> with SingleTickerProviderStateMixin {
  final usuario = 'pdrolopes';
  late final Future<List<dynamic>> _postsFuture;

 static const LatLng _campusArapiraca = LatLng(-9.745653, -36.631347);

  @override
  void initState() {
    super.initState();
    _postsFuture = PostDao().listarPorAutor(usuario);
  }

  void _exibirMapaCampus(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.65,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Campus Arapiraca'),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: _campusArapiraca,
                  zoom: 16.0,
                ),
                markers: {
                  const Marker(
                    markerId: MarkerId('campus_arapiraca'),
                    position: _campusArapiraca,
                    infoWindow: InfoWindow(
                      title: 'Campus Arapiraca',
                      snippet: 'IFAL - Campus Arapiraca',
                    ),
                  ),
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(username: usuario),
                _buildTabBar(),
                //_buildPosts(),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery
                .of(context)
                .padding
                .top + 10,
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
          Row(
            children: [
              _buildChip(
                Icons.location_pin,
                'Abrir Página',
                onTap: () =>
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const MapaCampusPage()),
                    ),
              ),
              const SizedBox(width: 15),
              _buildChip(
                Icons.location_pin,
                'Abrir Modal',
                onTap: () => _exibirMapaCampus(context),
              ),
            ],
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
      side: const BorderSide(
        color: Colors.white,
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      padding: const EdgeInsets.only(right: 5),
      labelPadding: const EdgeInsets.only(left: 2, right: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildTabBar() {
    return DefaultTabController(
      length: 1,
      child: Container(
        child: TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          indicatorColor: Cores.verde,
          indicatorWeight: 3.0,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [Tab(text: "Posts")],
        ),
      ),
    );
  }

/* Widget _buildPosts() {
    return FutureBuilder<List<dynamic>>(
        future: _postsFuture,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(
            child: Column(
            mainAxisSize: MainAxisSize.min */

}