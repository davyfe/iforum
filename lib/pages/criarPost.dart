import 'package:flutter/material.dart';
import '/widget/buildText.dart';
import '/cores.dart';
import '/domain/post.dart';
import '/db/postDao.dart';

class CriarPost extends StatefulWidget {
  const CriarPost({super.key});

  @override
  State<CriarPost> createState() => _CriarPostState();
}

class _CriarPostState extends State<CriarPost> {
  final _tituloC = TextEditingController();
  final _conteudoC = TextEditingController();
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

    final post = Post(
      titulo: titulo,
      autor: 'pdrolopes',
      tempo: 'agora mesmo',
      conteudo: _conteudoC.text.trim(),
    );
    await PostDao().inserirPost(post);
    setState(() => _salvo = false);

    if (mounted) {
      Navigator.of(context).pop(true); // se criou um post, true
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      resizeToAvoidBottomInset: true, // para aparecer o teclado
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          _salvo
              ? const Padding(
                  padding: EdgeInsetsGeometry.only(right: 18),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
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
        backgroundColor: Cores.fundo,
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
              _buildFormatacao(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatacao() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIcones(Icons.format_bold),
        _buildIcones(Icons.format_italic),
        _buildIcones(Icons.format_underline),
        _buildIcones(Icons.format_size),
        _buildIcones(Icons.strikethrough_s),
        _buildIcones(Icons.format_list_bulleted),
        _buildIcones(Icons.link),
        _buildIcones(Icons.attach_file),
        _buildIcones(Icons.image),
        _buildIcones(Icons.play_circle_filled),
      ],
    );
  }

  Widget _buildIcones(IconData icon) {
    return Icon(icon, color: Colors.black);
  }
}
