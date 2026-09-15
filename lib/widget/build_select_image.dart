import 'package:flutter/material.dart';
import '/api/imagem_api.dart';

class SelecionarImagemDialog extends StatefulWidget {
  final String categoriaInicial;
  final int quantidadeInicial;

  const SelecionarImagemDialog({
    super.key,
    this.categoriaInicial = '',
    this.quantidadeInicial = 9,
  });

  @override
  State<SelecionarImagemDialog> createState() => _SelecionarImagemDialogState();
}

class _SelecionarImagemDialogState extends State<SelecionarImagemDialog> {
  final _categoriaController = TextEditingController();

  List<String> imagens = [];
  bool carregando = false;
  bool jaPesquisou = false;
  late int quantidade;

  @override
  void initState() {
    super.initState();
    _categoriaController.text = widget.categoriaInicial;
    quantidade = widget.quantidadeInicial;

    // se já veio uma categoria pronta, busca direto
    if (widget.categoriaInicial.isNotEmpty) {
      _buscar();
    }
  }

  @override
  void dispose() {
    _categoriaController.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    final categoria = _categoriaController.text.trim();
    if (categoria.isEmpty) return;

    setState(() {
      carregando = true;
      jaPesquisou = true;
    });

    final imagemApi = ImagemApi();
    final resultado = await imagemApi.buscaPorImagem(
      categoria,
      quantidade: quantidade,
    );

    if (!mounted) return;
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
        height: 480,
        child: Column(
          children: [
            const Text(
              'Escolha uma imagem',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildFormulario(),
            const SizedBox(height: 12),
            Expanded(child: _buildResultado()),
          ],
        ),
      ),
    );
  }

  Widget _buildFormulario() {
    return Column(
      children: [
        TextField(
          controller: _categoriaController,
          decoration: const InputDecoration(
            labelText: 'Categoria',
            hintText: 'Ex: praia, natureza, cidade...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _buscar(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text('Quantidade de fotos:'),
            Expanded(
              child: Slider(
                value: quantidade.toDouble(),
                min: 3,
                max: 30,
                divisions: 27,
                label: '$quantidade',
                onChanged: (valor) {
                  setState(() => quantidade = valor.round());
                },
              ),
            ),
            Text('$quantidade'),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: carregando ? null : _buscar,
            child: const Text('Buscar imagens'),
          ),
        ),
      ],
    );
  }

  Widget _buildResultado() {
    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!jaPesquisou) {
      return const Center(
        child: Text(
          'Digite uma categoria e toque em "Buscar imagens"',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    if (imagens.isEmpty) {
      return const Center(child: Text('Nenhuma imagem encontrada'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}