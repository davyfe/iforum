import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '/domain/user.dart';

class SharedPrefs {
  Future<void> setUserStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('USER', value);
  }

  Future<bool> getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool('USER');
    return value ?? false;
  }

  Future<void> salvarUsuarioLocal(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> lista = prefs.getStringList('USUARIOS_LOCAIS') ?? [];
    lista.add(jsonEncode(user.toJson()));
    await prefs.setStringList('USUARIOS_LOCAIS', lista);
  }

  Future<List<User>> obterUsuariosLocais() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> lista = prefs.getStringList('USUARIOS_LOCAIS') ?? [];
    return lista.map((s) => User.fromJson(jsonDecode(s))).toList();
  }
}