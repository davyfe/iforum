import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/api/emprestimo_api.dart';
import '/domain/emprestimo.dart';
import '/cores.dart';

class EmprestimosPage extends StatefulWidget {
  const EmprestimosPage({super.key});

  @override
  State<EmprestimosPage> createState() => _EmprestimosPageState();
}

class _EmprestimosPageState extends State<EmprestimosPage> {
  late Future<List<Emprestimo>> futureAtuais = EmprestimoApi().listarAtuais();
  late Future<List<Emprestimo>> futureAntigos = EmprestimoApi().listarAntigos();

  void recarregar() {
    setState(() {
      futureAtuais = EmprestimoApi().listarAtuais();
      futureAntigos = EmprestimoApi().listarAntigos();
    });
  }

  String _formatarData(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  DateTime _parseData(String d) {
    final p = d.split('/');
    return DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
  }

  Future<void> _devolver(Emprestimo e) async {
    await EmprestimoApi().devolver(e.id!, _formatarData(DateTime.now()));
    recarregar();
  }

  Future<void> _renovar(Emprestimo e) async {
    if (e.renovacoes >= 3) return;
    final novaData = _parseData(e.dataPrevista).add(const Duration(days: 14));
    await EmprestimoApi().renovar(
      e.id!,
      _formatarData(novaData),
      e.renovacoes + 1,
    );
    recarregar();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          children: [
            _buildLista(futureAtuais, atual: true),
            _buildLista(futureAntigos, atual: false),
          ],
        ),
      ),
    );
  }

  Widget _buildLista(Future<List<Emprestimo>> future, {required bool atual}) {
    return FutureBuilder<List<Emprestimo>>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final lista = snapshot.data!;
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

  Widget _buildCard(Emprestimo e, {required bool atual}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildText(e.tituloLivro, bold: true),
          BuildText(e.autorLivro, size: 13, color: Cores.textoTerciario),
          const SizedBox(height: 6),
          BuildText(
            'Emprestado em ${e.dataEmprestimo}',
            size: 12,
            color: Cores.textoTerciario,
          ),
          BuildText(
            atual
                ? 'Devolução até ${e.dataPrevista}'
                : 'Devolvido em ${e.dataDevolucao}',
            size: 12,
            color: atual ? Colors.redAccent : Cores.textoTerciario,
          ),
          if (atual) ...[
            BuildText(
              'Renovações: ${e.renovacoes}/3',
              size: 12,
              color: Cores.textoTerciario,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: e.renovacoes >= 3 ? null : () => _renovar(e),
                    child: const Text('Renovar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _devolver(e),
                    child: const Text('Devolver'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
