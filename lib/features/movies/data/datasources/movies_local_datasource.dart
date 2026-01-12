
import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie_hive_model.dart';

class MoviesLocalDatasource {
  static const String boxName = 'movies_box';
  static const int _pageSize = 20;

  Future<Box<MovieHiveModel>> _openBox() async {
    return Hive.openBox<MovieHiveModel>(boxName);
  }

  Future<void> saveMovies(String cacheKey, List<MovieHiveModel> movies) async {
    final box = await _openBox();
    for (final movie in movies) {
      await box.put('${cacheKey}_${movie.id}', movie);
    }
    await box.close();
  }

  Future<List<MovieHiveModel>?> getMovies(String cacheKey) async {
    final box = await _openBox();

    final exact = box.values.where((m) => m.cacheKey == cacheKey).toList();
    if (exact.isNotEmpty) {
      await box.close();
      return exact;
    }

    if (cacheKey.startsWith('search_') && cacheKey.contains('_page_')) {
      final parts = cacheKey.replaceFirst('search_', '').split('_page_');
      final query = parts[0];
      final page = int.tryParse(parts.length > 1 ? parts[1] : '1') ?? 1;

      final filtered = box.values
          .where((m) => m.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      final start = (page - 1) * _pageSize;
      final paged = start < filtered.length
          ? filtered.skip(start).take(_pageSize).toList()
          : <MovieHiveModel>[];

      await box.close();
      return paged;
    }

    await box.close();
    return [];
  }
}


