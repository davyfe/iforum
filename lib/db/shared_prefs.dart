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
}
