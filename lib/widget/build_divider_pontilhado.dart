import 'package:flutter/material.dart';

class BuildDividerPontilhado extends StatelessWidget {
  final Color cor;
  final double altura;

  const BuildDividerPontilhado({
    super.key,
    this.cor = Colors.black26,
    this.altura = 1,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, altura),
      painter: _DividerPontilhadoPainter(cor: cor, altura: altura),
    );
  }
}

class _DividerPontilhadoPainter extends CustomPainter {
  final Color cor;
  final double altura;

  _DividerPontilhadoPainter({required this.cor, required this.altura});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cor
      ..strokeWidth = altura;

    const larguraTraco = 4.0;
    const espacoTraco = 4.0;
    double x = 0;

    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + larguraTraco, 0), paint);
      x += larguraTraco + espacoTraco;
    }
  }

  @override
  bool shouldRepaint(covariant _DividerPontilhadoPainter oldDelegate) {
    return oldDelegate.cor != cor || oldDelegate.altura != altura;
  }
}
