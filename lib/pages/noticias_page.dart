import 'package:flutter/material.dart';
import '/api/noticia_api.dart';
import '/api/noticia_ifal_api.dart';
import '/domain/noticia.dart';
import '/domain/noticia_ifal.dart';
import '/widget/build_noticia.dart';
import '/widget/build_noticia_ifal.dart';
import '/widget/build_estado.dart';
import '/widget/build_text.dart';

class Noticias extends StatefulWidget {
  const Noticias({super.key});

  @override
  State<Noticias> createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late Future<List<Noticia>> futureNoticias;
  late Future<List<NoticiaIfal>> futureNoticiasIfal;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    futureNoticias = NoticiaApi().listarNoticias();
    futureNoticiasIfal = NoticiaIfalApi().listarNoticiasIfal();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void recarregar() {
    setState(() {
      if (_tabController.index == 0) {
        futureNoticias = NoticiaApi().listarNoticias();
      } else {
        futureNoticiasIfal = NoticiaIfalApi().listarNoticiasIfal();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BuildText('Notícias', bold: true, size: 20),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          onTap: (_) => setState(() {}),
          tabs: const [
            Tab(text: 'Comunidade'),
            Tab(text: 'IFAL'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: recarregar,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildComunidade(), _buildIfal()],
      ),
    );
  }

  Widget _buildComunidade() {
    return FutureBuilder<List<Noticia>>(
      future: futureNoticias,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const BuildEstado(
            icone: Icons.error_outline,
            mensagem: 'Erro ao carregar notícias',
          );
        }
        final lista = snapshot.data ?? [];
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: lista.length,
          itemBuilder: (context, i) => BuildNoticia(noticia: lista[i]),
        );
      },
    );
  }

  Widget _buildIfal() {
    return FutureBuilder<List<NoticiaIfal>>(
      future: futureNoticiasIfal,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const BuildEstado(
            icone: Icons.error_outline,
            mensagem: 'Erro ao carregar notícias do IFAL',
          );
        }
        final lista = snapshot.data ?? [];
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: lista.length,
          itemBuilder: (context, i) => BuildNoticiaIfal(noticia: lista[i]),
        );
      },
    );
  }
}
