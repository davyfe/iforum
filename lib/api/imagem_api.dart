import 'package:dio/dio.dart';

class ImagemApi {
  final dio = Dio();
  static const String _accessKey = "1064303";


  Future<List<String>> buscaPorImagem(String categoria, {int quantidade = 9}) async {
    try {
      final response = await dio.get(
        "https://api.unsplash.com/search/photos",
        queryParameters: {
          'query': categoria,
          'client_id': _accessKey,
          'per_page': quantidade,
        },
      );
      final results = response.data['results'] as List;
      return results.map((foto) => foto['urls']['small'] as String).toList();
    } on DioException catch (e) {
      print('Erro ao buscar imagens: ${e.message}');
      return [];
    }
  }
}