class TextoEstilizado {
  static String negrito(String t) => t.split('').map(_negrito).join();
  static String italico(String t) => t.split('').map(_italico).join();
  static String sublinhado(String t) =>
      t.split('').map((c) => '$c\u0332').join();
  static String tachado(String t) => t.split('').map((c) => '$c\u0336').join();

  static String _negrito(String c) {
    final cod = c.codeUnitAt(0);
    if (cod >= 65 && cod <= 90) return String.fromCharCode(0x1D400 + cod - 65);
    if (cod >= 97 && cod <= 122) return String.fromCharCode(0x1D41A + cod - 97);
    if (cod >= 48 && cod <= 57) return String.fromCharCode(0x1D7CE + cod - 48);
    return c;
  }

  static String _italico(String c) {
    if (c == 'h') return '\u210E';
    final cod = c.codeUnitAt(0);
    if (cod >= 65 && cod <= 90) return String.fromCharCode(0x1D434 + cod - 65);
    if (cod >= 97 && cod <= 122) return String.fromCharCode(0x1D44E + cod - 97);
    return c;
  }
}
