import 'package:dio/dio.dart';
import '/domain/user.dart';
import '/db/shared_prefs.dart';

class UserApi {
  final dio = Dio();

  Future<List<User>> listarUsuarios() async {
    final response = await dio.get(
      'https://my-json-server.typicode.com/davyfe/fake_api/user',
    );

    List<User> lista = [];

    if (response.statusCode == 200) {
      for (var json in response.data) {
        lista.add(User.fromJson(json));
      }
    }
    return lista;
  }

  Future<bool> login(String username, String password) async {
    final usuariosApi = await listarUsuarios();
    final usuariosLocais = await SharedPrefs().obterUsuariosLocais();
    final todos = [...usuariosApi, ...usuariosLocais];

    return todos.any(
          (u) => u.username == username && u.password == password,
    );
  }

  Future<bool> usernameExiste(String username) async {
    final usuariosApi = await listarUsuarios();
    final usuariosLocais = await SharedPrefs().obterUsuariosLocais();

    return [...usuariosApi, ...usuariosLocais].any(
          (u) => u.username == username,
    );
  }

  Future<bool> registrar(User user) async {
    try {
      await dio.post(
        'https://my-json-server.typicode.com/davyfe/fake_api/user',
        data: user.toJson(),
      );
    } catch (_) {
    }

    await SharedPrefs().salvarUsuarioLocal(user);
    return true;
  }
}