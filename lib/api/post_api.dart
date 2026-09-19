import 'package:dio/dio.dart';
import '/domain/post.dart';

class PostsApi {
  final dio = Dio();
  static const _url =
      'https://my-json-server.typicode.com/davyfe/fake_api/post';

  Future<List<Post>> listarPosts() async {
    final response = await dio.get(_url);
    return (response.data as List).map((json) => Post.fromJson(json)).toList();
  }

  Future<void> criarPost(Post post) async {
    await dio.post(
      _url,
      data: {
        'titulo': post.titulo,
        'autor': post.autor,
        'tempo': post.tempo,
        'conteudo': post.conteudo,
        'urlImagem': post.urlImagem,
        'anexo': post.anexo,
        'likes': 0,
        'comentarios': 0,
      },
    );
  }
}
