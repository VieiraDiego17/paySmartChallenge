
import 'package:flutter_apps/features/movies/data/datasources/movies_local_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/search_movies.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/movies_remote_datasource.dart';
import '../../data/repositories/movies_repository_impl.dart';

final searchMoviesProvider =
StateNotifierProvider<SearchMoviesNotifier, AsyncValue<List<Movie>>>(
      (ref) {
    final dio = DioClient();
    final remote = MoviesRemoteDatasource(dio);
    final local = MoviesLocalDatasource();

    final repository = MoviesRepositoryImpl(remote: remote, local: local);
    final usecase = SearchMovies(repository);

    return SearchMoviesNotifier(usecase);
  },
);

class SearchMoviesNotifier
    extends StateNotifier<AsyncValue<List<Movie>>> {
  final SearchMovies searchMovies;

  int _page = 1;
  String _query = '';
  bool _isLoadingMore = false;

  SearchMoviesNotifier(this.searchMovies)
      : super(const AsyncData([]));

  Future<void> search(String query) async {
    if (query.isEmpty) return;

    _query = query;
    _page = 1;

    state = const AsyncLoading();

    try {
      final movies = await searchMovies(query, _page);
      state = AsyncData(movies);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  Future<void> fetchNextPage() async {
    if (_isLoadingMore || _query.isEmpty) return;

    _isLoadingMore = true;
    _page++;

    final current = state.value ?? [];

    try {
      final movies = await searchMovies(_query, _page);
      state = AsyncData([...current, ...movies]);
    } finally {
      _isLoadingMore = false;
    }
  }
}
