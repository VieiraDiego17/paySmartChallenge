import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class SearchMovies {
  final MoviesRepository repository;

  SearchMovies(this.repository);

  Future<List<Movie>> call(String query, int page) {
    return repository.searchMovies(query, page);
  }
}
