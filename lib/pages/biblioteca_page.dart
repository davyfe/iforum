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
  final _tiposBusca = {
    'geral': 'Geral',
    'titulo': 'Título',
    'autor': 'Autor',
    'isbn': 'ISBN',
  };
  String tipoBusca = 'geral';
  Future<List<Livro>>? futureBusca;
  late Future<List<Livro>> futurePopulares = BibliotecaApi().listarPopulares();

  Future<List<Livro>> _buscarPorIsbn(String isbn) async {
    final livro = await BibliotecaApi().buscarPorIsbn(isbn);
    return livro != null ? [livro] : [];
  }

  void _pesquisar(String termo) {
    final texto = termo.trim();
    setState(() {
      futureBusca = texto.isEmpty
          ? null
          : tipoBusca == 'isbn'
          ? _buscarPorIsbn(texto)
          : BibliotecaApi().pesquisarLivros(texto, tipo: tipoBusca);
    });
  }

  void _abrirFiltro() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: BuildText('Filtrar busca', bold: true, size: 18),
        children: [
          RadioGroup<String>(
            groupValue: tipoBusca,
            onChanged: (v) {
              setState(() => tipoBusca = v!);
              Navigator.of(context).pop();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var chave in _tiposBusca.keys)
                  RadioListTile<String>(
                    value: chave,
                    title: BuildText(_tiposBusca[chave]!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
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
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EmprestimosPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildBarraPesquisa(),
          Expanded(
            child: FutureBuilder<List<Livro>>(
              future: futureBusca ?? futurePopulares,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: BuildText(
                      'Erro ao buscar livros',
                      color: Colors.red,
                    ),
                  );
                }
                final livros = snapshot.data!;
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    BuildText(
                      futureBusca == null ? 'Populares' : 'Resultados',
                      bold: true,
                      size: 18,
                    ),
                    const SizedBox(height: 10),
                    if (livros.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: BuildText(
                            'Nenhum livro encontrado',
                            color: Cores.textoTerciario,
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: livros.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.55,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemBuilder: (context, i) =>
                            BuildLivroCard(livro: livros[i]),
                      ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarraPesquisa() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: _abrirFiltro,
            icon: Icon(
              Icons.filter_list,
              color: tipoBusca != 'geral' ? Cores.verde : Cores.textoTerciario,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _buscaController,
              onChanged: _pesquisar,
              decoration: InputDecoration(
                hintText: tipoBusca == 'isbn'
                    ? 'Digite o ISBN...'
                    : 'Pesquisar livros...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
