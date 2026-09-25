import 'package:flutter/material.dart';
import '/widget/build_text.dart';
import '/cores.dart';
import '/api/user_api.dart';
import '/db/shared_prefs.dart';
import '/domain/user.dart';
import 'home_page.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _ocultarSenha = true;
  bool _ocultarConfirmarSenha = true;
  bool _carregando = false;

  @override
  void dispose() {
    _usuarioController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _cadastrar() async {
    final usuario = _usuarioController.text.trim();
    final senha = _senhaController.text;
    final confirmarSenha = _confirmarSenhaController.text;

    if (usuario.isEmpty || senha.isEmpty || confirmarSenha.isEmpty) {
      _mostrarErro('Preencha todos os campos.');
      return;
    }

    if (senha.length < 4) {
      _mostrarErro('A senha deve ter pelo menos 4 caracteres.');
      return;
    }

    if (senha != confirmarSenha) {
      _mostrarErro('As senhas não coincidem.');
      return;
    }

    setState(() => _carregando = true);

    try {
      final jaExiste = await UserApi().usernameExiste(usuario);

      if (jaExiste) {
        if (!mounted) return;
        _mostrarErro('Esse nome de usuário já está em uso.');
        return;
      }

      await UserApi().registrar(User(usuario, senha));
      await SharedPrefs().setUserStatus(true);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarErro('Erro ao conectar. Tente novamente.');
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
              decoration: BoxDecoration(color: Cores.verde),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.forum_rounded,
                      size: 40,
                      color: Cores.verde,
                    ),
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
                    'Criar sua conta',
                    size: 20,
                    bold: true,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _usuarioController,
                    decoration: InputDecoration(
                      labelText: 'Nome de usuário',
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
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmarSenhaController,
                    obscureText: _ocultarConfirmarSenha,
                    decoration: InputDecoration(
                      labelText: 'Confirmar senha',
                      labelStyle: TextStyle(color: Cores.textoSecundario),
                      prefixIcon: Icon(Icons.lock_outline, color: Cores.verde),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarConfirmarSenha
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Cores.verde,
                        ),
                        onPressed: () {
                          setState(() {
                            _ocultarConfirmarSenha = !_ocultarConfirmarSenha;
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
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _carregando ? null : _cadastrar,
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
                        : BuildText('CADASTRAR', size: 16, bold: true),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BuildText(
                        'Já tem uma conta? ',
                        color: Cores.textoSecundario,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: BuildText(
                          'Entrar',
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
