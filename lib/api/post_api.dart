import 'package:dio/dio.dart';
import '/domain/post.dart';

class PostsApi {
  final dio = Dio();

  Future<List<Post>> listarPosts() async {
    final response = await dio.get(
      'https://my-json-server.typicode.com/davyfe/fake_api/post',
    );

    List<Post> lista = [];

    if (response.statusCode == 200) {
      for (var json in response.data) {
        Post post = Post.fromJson(json);
        lista.add(post);
      }
    }
    return lista;
  }
}
