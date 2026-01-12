import '../models/movie_model.dart';
import '../models/movie_hive_model.dart';

extension MovieApiToHiveMapper on MovieModel {
  MovieHiveModel toHive(String cacheKey) {
    return MovieHiveModel(
      id: id,
      title: title,
      posterPath: posterPath ?? '',
      overview: overview,
      releaseDate: releaseDate,
      cacheKey: cacheKey,
      genreIds: genreIds,
    );
  }
}

