import 'package:flutter/material.dart';
import 'package:iforum/widget/build_text.dart';
import '/cores.dart';
import '/api/user_api.dart';
import '/db/shared_prefs.dart';
import 'package:iforum/pages/home_page.dart';
import 'registro_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _ocultarSenha = true;
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final usuario = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (usuario.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha usuário e senha.')),
      );
      return;
    }

    setState(() => _carregando = true);

    try {
      final autenticado = await UserApi().login(usuario, senha);

      if (!mounted) return;

      if (autenticado) {
        await SharedPrefs().setUserStatus(true);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário ou senha inválidos.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao conectar. Tente novamente.')),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 80,
                bottom: 40,
                left: 24,
                right: 24,
              ),
              decoration: BoxDecoration(
                color: Cores.verde,
                // borderRadius: const BorderRadius.only(
                //   bottomLeft: Radius.circular(24),
                //   bottomRight: Radius.circular(24),
                // ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.school, size: 40, color: Cores.verde),
                  ),
                  const SizedBox(height: 16),
                  BuildText(
                    'IFORUM',
                    size: 28,
                    bold: true,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  BuildText(
                    'Conectando a comunidade acadêmica',
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  BuildText(
                    'Entrar na sua conta',
                    size: 20,
                    bold: true,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-mail ou usuário',
                      labelStyle: TextStyle(color: Cores.textoSecundario),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Cores.verde,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Cores.textoTerciario.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Cores.textoTerciario.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Cores.verde, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: _ocultarSenha,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Cores.textoSecundario),
                      prefixIcon: Icon(Icons.lock_outline, color: Cores.verde),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarSenha
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Cores.verde,
                        ),
                        onPressed: () {
                          setState(() {
                            _ocultarSenha = !_ocultarSenha;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Cores.textoTerciario.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Cores.textoTerciario.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Cores.verde, width: 2),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Esqueceu a senha?',
                        style: TextStyle(
                          color: Cores.verde,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _carregando ? null : _entrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Cores.verde,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
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
                        : BuildText('ENTRAR', size: 16, bold: true),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BuildText(
                        'Ainda não tem conta? ',
                        color: Cores.textoSecundario,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistroPage(),
                            ),
                          );
                        },
                        child: BuildText(
                          'Cadastre-se',
                          color: Cores.verde,
                          bold: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
