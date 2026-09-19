import 'package:flutter/material.dart';
import 'package:iforum/pages/splash_page.dart';
import '/cores.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Cores.fundo,
        colorSchemeSeed: Cores.verde,
        appBarTheme: AppBarTheme(
          backgroundColor: Cores.verde,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const SplashPage(),
    ),
  );
}
