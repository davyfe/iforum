import 'package:dio/dio.dart';
import '/domain/post.dart';
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
      dio.post('"https://my-json-server.typicode.com/davyfe/fake_api/post', data: {
        'titulo': post.titulo,
        'autor': post.autor,
        'tempo': post.tempo,
        'conteudo': post.conteudo,
        'likes': post.likes,
        'comentarios': post.comentarios,
        'anexo': post.anexo ? 1 : 0,
        'urlImagem': post.urlImagem,
      } );
    }

    Future<void> deletarPost(int id) async {
      dio.delete('https://my-json-server.typicode.com/davyfe/fake_api/post',
          queryParameters: {'id': id});
    }

    // usado no posts tab na tela perfil
    Future<List<Post>> listarPorAutor(String autor) async {
     final response =  await dio.get('https://my-json-server.typicode.com/davyfe/fake_api/post');

     List<Post> lista = [];
     if (response.statusCode == 200) {
       for (var json in response.data) {
         Post post = Post.fromJson(json);
         lista.add(post);

       }
     }
     return lista;

    where: 'autor = ?');
    return result.map((json) => Post.fromJson(json)).toList();
    }


    // NOVO - usado na tela de pesquisa
    Future<List<Post>> buscarPorTitulo(String nomeInicial) async {
    Database db = await DbHelper().initDB();
    final result = await db.query(
    'POST',
    where: 'titulo LIKE ?',
    whereArgs: ['$nomeInicial%'],
    );
    return result.map((json) => Post.fromJson(json)).toList();
    }
    }



  }
}
