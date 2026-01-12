import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class GetUpcomingMovies {
  final MoviesRepository repository;

  GetUpcomingMovies(this.repository);

  Future<List<Movie>> call(int page) {
    return repository.getUpcomingMovies(page);
  }
}
