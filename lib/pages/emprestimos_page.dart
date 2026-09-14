import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/db/emprestimo_dao.dart';
import '/domain/emprestimo.dart';
import '/cores.dart';

class EmprestimosPage extends StatefulWidget {
  const EmprestimosPage({super.key});

  @override
  State<EmprestimosPage> createState() => _EmprestimosPageState();
}

class _EmprestimosPageState extends State<EmprestimosPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Emprestimo>> futureAtuais;
  late Future<List<Emprestimo>> futureAntigos;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _carregar();
  }

  void _carregar() {
    futureAtuais = EmprestimoDao().listarAtuais();
    futureAntigos = EmprestimoDao().listarAntigos();
  }

  void recarregar() => setState(_carregar);

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  DateTime _parseData(String data) {
    final partes = data.split('/');
    return DateTime(
      int.parse(partes[2]),
      int.parse(partes[1]),
      int.parse(partes[0]),
    );
  }

  Future<void> _devolver(Emprestimo emprestimo) async {
    await EmprestimoDao().devolver(
      emprestimo.id!,
      _formatarData(DateTime.now()),
    );
    recarregar();
  }

  Future<void> _renovar(Emprestimo emprestimo) async {
    if (emprestimo.renovacoes >= 3) return;

    final novaPrevisao = _parseData(
      emprestimo.dataPrevista,
    ).add(const Duration(days: 14));
    await EmprestimoDao().renovar(
      emprestimo.id!,
      _formatarData(novaPrevisao),
      emprestimo.renovacoes + 1,
    );
    recarregar();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Renovado até ${_formatarData(novaPrevisao)}.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Cores.verde,
        title: BuildText(
          'Meus empréstimos',
          bold: true,
          color: Colors.white,
          size: 18,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Atuais'),
            Tab(text: 'Histórico'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLista(futureAtuais, atual: true),
          _buildLista(futureAntigos, atual: false),
        ],
      ),
    );
  }

  Widget _buildLista(Future<List<Emprestimo>> future, {required bool atual}) {
    return FutureBuilder<List<Emprestimo>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final lista = snapshot.data ?? [];
        if (lista.isEmpty) {
          return Center(
            child: BuildText(
              atual
                  ? 'Nenhum empréstimo ativo'
                  : 'Nenhum empréstimo no histórico',
              color: Cores.textoTerciario,
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: lista.length,
          itemBuilder: (context, i) => _buildCard(lista[i], atual: atual),
        );
      },
    );
  }

  Widget _buildCard(Emprestimo emprestimo, {required bool atual}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 55,
              height: 78,
              child: emprestimo.capaUrl.isNotEmpty
                  ? Image.network(
                      emprestimo.capaUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.menu_book),
                    )
                  : const Icon(Icons.menu_book),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildText(
                  emprestimo.tituloLivro,
                  bold: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                BuildText(
                  emprestimo.autorLivro,
                  size: 13,
                  color: Cores.textoTerciario,
                ),
                const SizedBox(height: 6),
                BuildText(
                  'Emprestado em ${emprestimo.dataEmprestimo}',
                  size: 12,
                  color: Cores.textoTerciario,
                ),
                if (atual)
                  BuildText(
                    'Devolução até ${emprestimo.dataPrevista}',
                    size: 12,
                    color: Colors.redAccent,
                  )
                else
                  BuildText(
                    'Devolvido em ${emprestimo.dataDevolucao}',
                    size: 12,
                    color: Cores.textoTerciario,
                  ),
                if (atual) ...[
                  const SizedBox(height: 4),
                  BuildText(
                    'Renovações: ${emprestimo.renovacoes}/3',
                    size: 12,
                    color: Cores.textoTerciario,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: emprestimo.renovacoes >= 3
                              ? null
                              : () => _renovar(emprestimo),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Cores.verde),
                            shape: const StadiumBorder(),
                          ),
                          child: BuildText(
                            'Renovar',
                            color: Cores.verde,
                            size: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _devolver(emprestimo),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Cores.verde,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Devolver',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
