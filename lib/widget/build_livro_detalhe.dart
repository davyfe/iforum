import 'package:flutter/material.dart';
import '/domain/livro.dart';
import '/domain/emprestimo.dart';
import '/domain/notificacao.dart';
import '/api/emprestimo_api.dart';
import '/db/notificacao_dao.dart';
import '/cores.dart';
import 'build_text.dart';

class BuildLivroDetalhe extends StatefulWidget {
  final Livro livro;

  const BuildLivroDetalhe({super.key, required this.livro});

  @override
  State<BuildLivroDetalhe> createState() => _BuildLivroDetalheState();
}

class _BuildLivroDetalheState extends State<BuildLivroDetalhe> {
  bool _carregando = false;
  bool _jaEmprestado = false;

  @override
  void initState() {
    super.initState();
    _verificarEmprestimo();
  }

  Future<void> _verificarEmprestimo() async {
    final emprestado = await EmprestimoApi().estaEmprestado(widget.livro.isbn);
    if (mounted) setState(() => _jaEmprestado = emprestado);
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  Future<void> _emprestar() async {
    setState(() => _carregando = true);

    final agora = DateTime.now();
    final previsao = agora.add(const Duration(days: 14));

    await EmprestimoApi().emprestar(
      Emprestimo(
        tituloLivro: widget.livro.titulo,
        autorLivro: widget.livro.autor,
        capaUrl: widget.livro.capaUrl,
        isbn: widget.livro.isbn,
        dataEmprestimo: _formatarData(agora),
        dataPrevista: _formatarData(previsao),
      ),
    );

    await NotificacaoDao().inserirNotificacao(
      Notificacao(
        titulo: 'Empréstimo realizado',
        mensagem:
            '"${widget.livro.titulo}" deve ser devolvido até ${_formatarData(previsao)}.',
        tipo: 'emprestimo',
        data: _formatarData(agora),
      ),
    );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Livro emprestado! Devolução até ${_formatarData(previsao)}.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 80,
                  height: 110,
                  child: widget.livro.capaUrl.isNotEmpty
                      ? Image.network(
                          widget.livro.capaUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.menu_book, size: 40),
                        )
                      : const Icon(Icons.menu_book, size: 40),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildText(
                      widget.livro.titulo,
                      bold: true,
                      size: 18,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    BuildText(widget.livro.autor, color: Cores.textoTerciario),
                    if (widget.livro.ano.isNotEmpty)
                      BuildText(
                        'Ano: ${widget.livro.ano}',
                        color: Cores.textoTerciario,
                        size: 13,
                      ),
                    if (widget.livro.isbn.isNotEmpty)
                      BuildText(
                        'ISBN: ${widget.livro.isbn}',
                        color: Cores.textoTerciario,
                        size: 13,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_carregando || _jaEmprestado) ? null : _emprestar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Cores.verde,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _carregando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _jaEmprestado ? 'Já emprestado' : 'Emprestar (14 dias)',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
