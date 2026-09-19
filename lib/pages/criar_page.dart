import 'package:flutter/material.dart';
import '../api/post_api.dart';
import '../db/shared_prefs.dart';
import '../widget/texto_estilizado.dart';
import '/widget/build_select_image.dart';
import '/widget/build_text.dart';
import '/cores.dart';
import '/domain/post.dart';

class CriarPost extends StatefulWidget {
  const CriarPost({super.key});

  @override
  State<CriarPost> createState() => _CriarPostState();
}

class _CriarPostState extends State<CriarPost> {
  final _tituloC = TextEditingController();
  final _conteudoC = TextEditingController();
  String _urlImagem = '';
  bool _anexo = false;
  bool _enviando = false;

  void _aplicarFormatacao(String Function(String) f) {
    final s = _conteudoC.selection;
    if (!s.isValid || s.isCollapsed) return;
    final texto = _conteudoC.text;
    final novo = texto.replaceRange(
      s.start,
      s.end,
      f(texto.substring(s.start, s.end)),
    );
    _conteudoC.value = TextEditingValue(
      text: novo,
      selection: TextSelection.collapsed(
        offset: s.start + f(texto.substring(s.start, s.end)).length,
      ),
    );
  }

  void _inserirMarcador(String marcador) {
    final pos = _conteudoC.selection.start < 0
        ? _conteudoC.text.length
        : _conteudoC.selection.start;
    final novo = _conteudoC.text.replaceRange(pos, pos, marcador);
    _conteudoC.value = TextEditingValue(
      text: novo,
      selection: TextSelection.collapsed(offset: pos + marcador.length),
    );
  }

  Future<void> _postar() async {
    final titulo = _tituloC.text.trim();
    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um título para o post.')),
      );
      return;
    }
    setState(() => _enviando = true);
    final autor = await SharedPrefs().getUsername() ?? 'anonimo';
    await PostsApi().criarPost(
      Post(
        titulo: titulo,
        autor: autor,
        tempo: 'agora mesmo',
        conteudo: _conteudoC.text.trim(),
        urlImagem: _urlImagem,
        anexo: _anexo,
      ),
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  Widget _buildFormatacao() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _aplicarFormatacao(TextoEstilizado.negrito),
          icon: const Icon(Icons.format_bold),
        ),
        IconButton(
          onPressed: () => _aplicarFormatacao(TextoEstilizado.italico),
          icon: const Icon(Icons.format_italic),
        ),
        IconButton(
          onPressed: () => _aplicarFormatacao(TextoEstilizado.sublinhado),
          icon: const Icon(Icons.format_underline),
        ),
        IconButton(
          onPressed: () => _aplicarFormatacao(TextoEstilizado.tachado),
          icon: const Icon(Icons.strikethrough_s),
        ),
        IconButton(
          onPressed: () => _inserirMarcador('\n• '),
          icon: const Icon(Icons.format_list_bulleted),
        ),
        IconButton(
          onPressed: () => _aplicarFormatacao((s) => '[$s](url)'),
          icon: const Icon(Icons.link),
        ),
        IconButton(
          onPressed: () => setState(() => _anexo = !_anexo),
          icon: Icon(
            Icons.attach_file,
            color: _anexo ? Cores.verde : Colors.black54,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.image_search),
          onPressed: () async {
            final url = await showDialog<String>(
              context: context,
              builder: (context) =>
                  const SelecionarImagemDialog(categoria: 'campus'),
            );
            if (url != null) setState(() => _urlImagem = url);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          _enviando
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
}
