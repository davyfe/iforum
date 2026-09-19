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

  Future<void> inserirPost(Post post) async {
    await dio.post(
      'https://my-json-server.typicode.com/davyfe/fake_api/post',
      data: {
        'titulo': post.titulo,
        'autor': post.autor,
        'tempo': post.tempo,
        'conteudo': post.conteudo,
        'likes': post.likes,
        'comentarios': post.comentarios,
        'anexo': post.anexo ? 1 : 0,
        'urlImagem': post.urlImagem,
      },
    );
  }

  Future<void> deletarPost(int id) async {
    await dio.delete(
      'https://my-json-server.typicode.com/davyfe/fake_api/post',
      queryParameters: {'id': id},
    );
  }

  // Usado no posts tab na tela perfil
  Future<List<Post>> listarPorAutor(String autor) async {
    final response = await dio.get(
      'https://my-json-server.typicode.com/davyfe/fake_api/post',
    );

    List<Post> lista = [];
    if (response.statusCode == 200) {
      for (var json in response.data) {
        Post post = Post.fromJson(json);
        if (post.autor.toLowerCase() == autor.toLowerCase()) {
          lista.add(post);
        }
      }
    }
    return lista;
  }
}