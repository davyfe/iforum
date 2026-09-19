import 'package:flutter/material.dart';
import '/widget/build_select_image.dart';
import '/widget/build_text.dart';
import '/cores.dart';
import '/domain/post.dart';
import '/api/post_api.dart'; // Ajustado para usar a API web se esse for o seu fluxo principal

class CriarPost extends StatefulWidget {
  const CriarPost({super.key});

  @override
  State<CriarPost> createState() => _CriarPostState();
}

class _CriarPostState extends State<CriarPost> {
  final _tituloC = TextEditingController();
  final _conteudoC = TextEditingController();
  String _urlImagem = '';
  bool _salvo = false;

  @override
  void dispose() {
    _tituloC.dispose();
    _conteudoC.dispose();
    super.dispose();
  }

  void _postar() async {
    final titulo = _tituloC.text.trim();
    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um título para o post.')),
      );
      return;
    }
    setState(() => _salvo = true);

    // Criando o objeto Post com todos os parâmetros necessários exigidos pelo modelo
    final post = Post(
      titulo: titulo,
      autor: 'pdrolopes',
      tempo: 'agora mesmo',
      conteudo: _conteudoC.text.trim(),
      likes: 0,
      comentarios: 0,
      anexo: _urlImagem.isNotEmpty,
      urlImagem: _urlImagem,
    );

    try {
      // Se estiver usando API web via Dio:
      await PostsApi().inserirPost(post);

      // Caso queira usar banco local SQLite em vez da API, descomente a linha abaixo:
      // await PostDao().inserirPost(post);

      setState(() => _salvo = false);

      if (mounted) {
        Navigator.of(context).pop(true); // Retorna true informando que criou com sucesso
      }
    } catch (e) {
      setState(() => _salvo = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar post: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Cores.fundo,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          _salvo
              ? const Padding(
            padding: EdgeInsets.only(right: 18), // Corrigido de EdgeInsetsGeometry para EdgeInsets
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black, // Alterado para preto para aparecer bem no fundo claro
              ),
            ),
          )
              : Padding(
            padding: const EdgeInsets.only(right: 15),
            child: ElevatedButton(
              onPressed: _postar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Cores.verde,
                shape: const StadiumBorder(),
                elevation: 0,
                minimumSize: const Size(0, 30),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              child: BuildText(
                'postar',
                color: Colors.white,
                size: 18,
                bold: true,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _tituloC,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Digite um título...',
                  hintStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextField(
                controller: _conteudoC,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Digite um pouco de texto... (opcional)',
                  hintStyle: TextStyle(fontSize: 18, color: Colors.black38),
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(height: 20),
              // Exibe indicador visual se houver imagem selecionada
              if (_urlImagem.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      const Icon(Icons.image, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Imagem anexada com sucesso',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => setState(() => _urlImagem = ''),
                      ),
                    ],
                  ),
                ),
              _buildFormatacao(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatacao() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcones(Icons.format_bold),
          _buildIcones(Icons.format_italic),
          _buildIcones(Icons.format_underline),
          _buildIcones(Icons.format_size),
          _buildIcones(Icons.strikethrough_s),
          _buildIcones(Icons.format_list_bulleted),
          _buildIcones(Icons.link),
          _buildIcones(Icons.attach_file),
          IconButton(
            icon: const Icon(Icons.image, color: Colors.black),
            onPressed: () async {
              final urlEscolhida = await showDialog<String>(
                context: context,
                builder: (context) => const SelecionarImagemDialog(),
              );

              if (urlEscolhida != null) {
                setState(() {
                  _urlImagem = urlEscolhida;
                });
              }
            },
          ),
          _buildIcones(Icons.play_circle_filled),
        ],
      ),
    );
  }

  Widget _buildIcones(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(icon, color: Colors.black),
    );
  }
}