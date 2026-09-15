import 'package:flutter/material.dart';
import '/api/imagem_api.dart';

class SelecionarImagemDialog extends StatefulWidget {
  final String categoria;
  const SelecionarImagemDialog({super.key, required this.categoria});

  @override
  State<SelecionarImagemDialog> createState() => _SelecionarImagemDialogState();
}

class _SelecionarImagemDialogState extends State<SelecionarImagemDialog> {
  List<String> imagens = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarImagens();
  }

  Future<void> _carregarImagens() async {
    final imagemApi = ImagemApi();
    final resultado = await imagemApi.buscaPorImagem(widget.categoria);
    setState(() {
      imagens = resultado;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(12),
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            const Text(
              'Escolha uma imagem',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: carregando
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                      itemCount: imagens.length,
                      itemBuilder: (context, index) {
                        final url = imagens[index];
                        return GestureDetector(
                          onTap: () => Navigator.pop(context, url),
                          child: Image.network(url, fit: BoxFit.cover),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
