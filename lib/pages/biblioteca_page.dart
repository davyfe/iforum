import 'package:flutter/material.dart';
import '/widget/build_estado.dart';
import '/widget/build_filtro_dialog.dart';
import '/widget/build_search_bar.dart';
import '/api/biblioteca_api.dart';
import '/domain/livro.dart';
import '/widget/build_text.dart';
import '/widget/build_livro_card.dart';
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

  void _abrirFiltro() async {
    const opcoes = [
      OpcaoFiltro('geral', 'Geral'),
      OpcaoFiltro('titulo', 'Título'),
      OpcaoFiltro('autor', 'Autor'),
      OpcaoFiltro('isbn', 'ISBN'),
    ];
    final valor = await mostrarFiltro<String>(
      context,
      titulo: 'Filtrar busca',
      opcoes: opcoes,
      valorAtual: tipoBusca,
    );
    if (valor != null) {
      setState(() => tipoBusca = valor);
      if (_buscaController.text.isNotEmpty) _pesquisar(_buscaController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BuildText('Biblioteca', bold: true, size: 20),
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
          BuildSearchBar(
            controller: _buscaController,
            hint: tipoBusca == 'isbn'
                ? 'Digite o ISBN...'
                : 'Pesquisar livros...',
            onChanged: _pesquisar,
            filtroAtivo: tipoBusca != 'geral',
            onFiltro: _abrirFiltro,
          ),
          Expanded(
            child: futureBusca != null
                ? _buildResultadoBusca()
                : _buildPopulares(),
          ),
        ],
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
          return const BuildEstado(
            icone: Icons.error_outline,
            mensagem: 'Erro ao carregar livros populares.',
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
          return const BuildEstado(
            icone: Icons.error_outline,
            mensagem: 'Erro na pesquisa',
          );
        }
        final livros = snapshot.data ?? [];
        if (livros.isEmpty) {
          return const BuildEstado(
            icone: Icons.menu_book_outlined,
            mensagem: 'Nenhum livro encontrado',
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
