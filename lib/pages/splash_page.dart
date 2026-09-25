import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/cores.dart';
import '/db/shared_prefs.dart';
import '/pages/login_page.dart';
import '/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _verificarAutenticacao();
  }

  Future<void> _verificarAutenticacao() async {
    await Future.delayed(const Duration(seconds: 2));

    bool estaAutenticado = await _checarStatusLogin();

    if (!mounted) return;

    if (estaAutenticado) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Future<bool> _checarStatusLogin() async {
    return SharedPrefs().getUserStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.verde,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.school, size: 48, color: Cores.verde),
            ),
            const SizedBox(height: 24),
            BuildText('IFORUM', size: 32, bold: true, color: Colors.white),
            const SizedBox(height: 8),
            BuildText(
              'Conectando a comunidade acadêmica',
              size: 14,
              color: Colors.white.withValues(alpha: 0.85),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
