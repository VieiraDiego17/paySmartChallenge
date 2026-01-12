import '../entities/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getUpcomingMovies(int page);
  Future<List<Movie>> searchMovies(String query, int page);
  Future<void> refreshUpcoming(int page);
}

