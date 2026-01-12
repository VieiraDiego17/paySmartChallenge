import '../../../../core/network/dio_client.dart';
import '../models/movie_model.dart';

class MoviesRemoteDatasource {
  final DioClient client;

  MoviesRemoteDatasource(this.client);

  Future<List<MovieModel>> getUpcomingMovies(int page) async {
    final response = await client.dio.get(
      '/movie/upcoming',
      queryParameters: {'page': page},
    );

    final results = response.data['results'] as List;
    return results.map((e) => MovieModel.fromJson(e)).toList();
  }

  Future<List<MovieModel>> searchMovies(String query, int page) async {
    final response = await client.dio.get(
      '/search/movie',
      queryParameters: {
        'query': query,
        'page': page,
      },
    );

    final results = response.data['results'] as List;
    return results.map((e) => MovieModel.fromJson(e)).toList();
  }


}
