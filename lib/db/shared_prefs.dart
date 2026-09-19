import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '/domain/user.dart';

class SharedPrefs {
  Future<void> login(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('USERNAME', username);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('USERNAME');
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('USERNAME');
  }

  Future<void> setUserStatus(bool logado) async => logado ? null : logout();
  Future<bool> getUserStatus() async => (await getUsername()) != null;

  Future<void> salvarUsuarioLocal(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList('USUARIOS_LOCAIS') ?? [];
    lista.add(jsonEncode(user.toJson()));
    await prefs.setStringList('USUARIOS_LOCAIS', lista);
  }

  Future<List<User>> obterUsuariosLocais() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList('USUARIOS_LOCAIS') ?? [];
    return lista.map((s) => User.fromJson(jsonDecode(s))).toList();
  }

  Future<Set<int>> _obterSet(String chave) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(chave)?.map(int.parse).toSet() ?? {};
  }

  Future<bool> alternar(String chave, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final atual = await _obterSet(chave);
    final ativo = !atual.contains(id);
    ativo ? atual.add(id) : atual.remove(id);
    await prefs.setStringList(chave, atual.map((e) => e.toString()).toList());
    return ativo;
  }

  Future<Set<int>> postsFavoritos() => _obterSet('POSTS_FAVORITOS');
  Future<Set<int>> eventosFavoritos() => _obterSet('EVENTOS_FAVORITOS');
  Future<Set<int>> eventosInscritos() => _obterSet('EVENTOS_INSCRITOS');
}
