import '../repositories/movies_repository.dart';

class RefreshUpcomingMovies {
  final MoviesRepository repository;

  RefreshUpcomingMovies(this.repository);

  Future<void> call(int page) {
    return repository.refreshUpcoming(page);
  }
}
