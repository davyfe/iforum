import 'package:dio/dio.dart';
import '/domain/user.dart';

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
    final usuarios = await listarUsuarios();
    return usuarios.any(
          (u) => u.username == username && u.password == password,
    );
  }
}