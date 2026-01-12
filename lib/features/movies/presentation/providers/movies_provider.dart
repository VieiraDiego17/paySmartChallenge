import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_apps/features/movies/data/datasources/movies_local_datasource.dart';
import 'package:flutter_apps/features/movies/data/datasources/movies_remote_datasource.dart';
import 'package:flutter_apps/features/movies/data/repositories/movies_repository_impl.dart';
import 'package:flutter_apps/features/movies/domain/entities/movie.dart';
import 'package:flutter_apps/features/movies/domain/usecases/get_upcoming_movies.dart';
import 'package:flutter_apps/features/movies/domain/usecases/refresh_upcoming_movies.dart';
import '../../../../core/network/dio_client.dart';

enum RefreshResult {
  updated,
  noChanges,
  error,
}

final moviesRefreshingProvider = StateProvider<bool>((ref) => false);
final moviesRefreshEventProvider = StateProvider<bool>((ref) => false);

final moviesProvider =
StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final dio = DioClient();
  final remote = MoviesRemoteDatasource(dio);
  final local = MoviesLocalDatasource();

  final repository = MoviesRepositoryImpl(remote: remote, local: local);

  return MoviesNotifier(
    ref,
    GetUpcomingMovies(repository),
    RefreshUpcomingMovies(repository),
  );
});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  final Ref ref;
  final GetUpcomingMovies getUpcomingMovies;
  final RefreshUpcomingMovies refreshUpcomingMovies;

  int _page = 1;
  bool _isLoadingPage = false;

  MoviesNotifier(
      this.ref,
      this.getUpcomingMovies,
      this.refreshUpcomingMovies,
      ) : super([]) {
    fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (_isLoadingPage) return;
    _isLoadingPage = true;

    final movies = await getUpcomingMovies(_page);
    state = [...state, ...movies];
    _page++;

    _isLoadingPage = false;
  }

  bool _listsAreEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<RefreshResult> refresh() async {
    ref.read(moviesRefreshingProvider.notifier).state = true;

    final previousIds = state.map((e) => e.id).toList();

    try {
      _page = 1;

      await refreshUpcomingMovies(1);
    } catch (e) {
      debugPrint('Erro refresh: Erro no refresh remoto: $e');
    }

    try {
      final movies = await getUpcomingMovies(1);
      state = movies;

      final newIds = movies.map((e) => e.id).toList();

      if (_listsAreEqual(previousIds, newIds)) {
        return RefreshResult.noChanges;
      }

      return RefreshResult.updated;
    } catch (e) {
      debugPrint('Erro refresh: Erro ao carregar filmes: $e');

      if (state.isEmpty) {
        return RefreshResult.error;
      }

      return RefreshResult.noChanges;
    } finally {
      ref.read(moviesRefreshingProvider.notifier).state = false;
    }
  }



}
