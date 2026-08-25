import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildText extends StatelessWidget {
  final String text;
  final double? size;
  final bool bold;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;

  const BuildText(
    this.text, {
    super.key,
    this.size,
    this.bold = false,
    this.maxLines,
    this.overflow,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.inter(
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: color,
      ),
    );
  }
}
