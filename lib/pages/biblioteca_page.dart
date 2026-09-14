import 'package:flutter/material.dart';
import '/api/biblioteca_api.dart';
import '/domain/livro.dart';
import '/widget/build_text.dart';
import '/widget/build_livro_card.dart';
import '/cores.dart';
import 'emprestimos_page.dart';

class Biblioteca extends StatefulWidget {
  const Biblioteca({super.key});

  @override
  State<Biblioteca> createState() => _BibliotecaState();
}

class _BibliotecaState extends State<Biblioteca> {
  final _buscaController = TextEditingController();
  String tipoBusca = 'geral';
  Future<List<Livro>>? futureBusca;
  late Future<List<Livro>> futurePopulares;

  @override
  void initState() {
    super.initState();
    futurePopulares = BibliotecaApi().listarPopulares();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  void _pesquisar(String termo) {
    if (termo.trim().isEmpty) {
      setState(() => futureBusca = null);
      return;
    }
    setState(() {
      if (tipoBusca == 'isbn') {
        futureBusca = BibliotecaApi()
            .buscarPorIsbn(termo.trim())
            .then((livro) => livro != null ? [livro] : <Livro>[]);
      } else {
        futureBusca = BibliotecaApi().pesquisarLivros(
          termo.trim(),
          tipo: tipoBusca,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Cores.verde,
        title: BuildText(
          'Biblioteca',
          bold: true,
          color: Colors.white,
          size: 20,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Meus empréstimos',
            icon: const Icon(Icons.history_edu_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EmprestimosPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildBusca(),
          Expanded(
            child: futureBusca != null
                ? _buildResultadoBusca()
                : _buildPopulares(),
          ),
        ],
      ),
    );
  }

  Widget _buildBusca() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          TextField(
            controller: _buscaController,
            onSubmitted: _pesquisar,
            decoration: InputDecoration(
              hintText: tipoBusca == 'isbn'
                  ? 'Digite o ISBN...'
                  : 'Pesquisar livros...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _buscaController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _buscaController.clear();
                        setState(() => futureBusca = null);
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildFiltrosBusca(),
        ],
      ),
    );
  }

  Widget _buildFiltrosBusca() {
    final opcoes = {
      'geral': 'Geral',
      'titulo': 'Título',
      'autor': 'Autor',
      'isbn': 'ISBN',
    };

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: opcoes.entries.map((entry) {
          final selecionado = tipoBusca == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: selecionado,
              selectedColor: Cores.verde,
              labelStyle: TextStyle(
                color: selecionado ? Colors.white : Colors.black87,
              ),
              onSelected: (_) {
                setState(() => tipoBusca = entry.key);
                if (_buscaController.text.isNotEmpty)
                  _pesquisar(_buscaController.text);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPopulares() {
    return FutureBuilder<List<Livro>>(
      future: futurePopulares,
      builder: (context, snapshot) {
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
                BuildText(
                  'Erro ao carregar livros populares',
                  color: Colors.red,
                ),
              ],
            ),
          );
        }
        return _buildGrid(snapshot.data ?? [], titulo: 'Populares');
      },
    );
  }

  Widget _buildResultadoBusca() {
    return FutureBuilder<List<Livro>>(
      future: futureBusca,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: BuildText('Erro na pesquisa', color: Colors.red),
          );
        }
        final livros = snapshot.data ?? [];
        if (livros.isEmpty) {
          return Center(
            child: BuildText(
              'Nenhum livro encontrado',
              color: Cores.textoTerciario,
            ),
          );
        }
        return _buildGrid(livros, titulo: 'Resultados');
      },
    );
  }

  Widget _buildGrid(List<Livro> livros, {required String titulo}) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        BuildText(titulo, bold: true, size: 18),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: livros.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.55,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, i) => BuildLivroCard(livro: livros[i]),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
