import 'package:flutter/material.dart';
import '/domain/post.dart';
import '/pages/map_page.dart';
import '/locais.dart';
import '/cores.dart';
import '/widget/build_interaction.dart';
import '/widget/build_text.dart';

class DetailPage extends StatelessWidget {
  final Post post;

  const DetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Cores.verde),
        backgroundColor: Cores.fundo,
        title: const Text('Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Autor e tempo
            Row(
              children: [
                CircleAvatar(radius: 16, backgroundColor: Cores.avatar),
                const SizedBox(width: 10),
                BuildText(post.autor, bold: true),
                const SizedBox(width: 10),
                BuildText(post.tempo),
              ],
            ),
            const SizedBox(height: 12),

            // Local (abre o mapa)
            _buildLocal(context),
            const SizedBox(height: 12),

            // Título completo
            BuildText(post.titulo, size: 24, bold: true),

            // Conteúdo completo
            if (post.conteudo.isNotEmpty) ...[
              const SizedBox(height: 12),
              BuildText(post.conteudo),
            ],

            // Imagem
            if (post.urlImagem.isNotEmpty) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post.urlImagem,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
                ),
              ),
            ],

            const SizedBox(height: 16),
            BuildInteractionBar(
              likes: post.likes,
              comentarios: post.comentarios,
            ),
            const Divider(thickness: 0.5),

            // Espaço para a seção de comentários
            const SizedBox(height: 8),
            BuildText('Comentários', size: 18, bold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildLocal(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MapPage(
              location: Locais.campusArapiraca,
              titulo: 'Campus Arapiraca',
              descricao: 'IFAL - Campus Arapiraca',
            ),
          ),
        );
      },
      child: Row(
        children: [
          Icon(Icons.location_on, color: Cores.textoTerciario, size: 18),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              'Instituto Federal de Alagoas, campus Arapiraca',
              style: TextStyle(fontSize: 13, color: Cores.textoTerciario),
            ),
          ),
        ],
      ),
    );
  }
}