import 'package:flutter_apps/features/movies/data/models/movie_model.dart';

import '../../domain/entities/movie.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/movies_remote_datasource.dart';
import '../datasources/movies_local_datasource.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesRemoteDatasource remote;
  final MoviesLocalDatasource local;

  MoviesRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<List<Movie>> getUpcomingMovies(int page) async {
    final cacheKey = 'upcoming_page_$page';

    final cached = await local.getMovies(cacheKey);

    if (cached != null && cached.isNotEmpty) {
      _refreshUpcoming(page, cacheKey);
      return cached.map((e) => e.toEntity()).toList();
    }

    final remoteModels = await remote.getUpcomingMovies(page);

    await local.saveMovies(
      cacheKey,
      remoteModels.map((e) => e.toHive(cacheKey: cacheKey)).toList(),
    );

    return remoteModels.map((e) => e.toEntity()).toList();
  }


  @override
  Future<List<Movie>> searchMovies(String query, int page) async {
    final cacheKey = 'search_${query}_page_$page';

    final cached = await local.getMovies(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return cached.map((e) => e.toEntity()).toList();
    }

    final remoteModels = await remote.searchMovies(query, page);

    await local.saveMovies(
      cacheKey,
      remoteModels.map((e) => e.toHive(cacheKey: cacheKey)).toList(),
    );

    return remoteModels.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> refreshUpcoming(int page) async {
    final cacheKey = 'upcoming_page_$page';

    final remoteModels = await remote.getUpcomingMovies(page);

    await local.saveMovies(
      cacheKey,
      remoteModels.map((e) => e.toHive(cacheKey: cacheKey)).toList(),
    );
  }


  Future<void> _refreshUpcoming(int page, String cacheKey) async {
    try {
      final remoteModels = await remote.getUpcomingMovies(page);

      await local.saveMovies(
        cacheKey,
        remoteModels.map((e) => e.toHive(cacheKey: cacheKey)).toList(),
      );
    } catch (_) {
    }
  }


}
