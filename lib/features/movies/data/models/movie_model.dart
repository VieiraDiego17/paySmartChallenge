import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/movie.dart';
import 'package:flutter_apps/features/movies/data/models/movie_hive_model.dart';


part 'movie_model.freezed.dart';
part 'movie_model.g.dart';

@freezed
class MovieModel with _$MovieModel {
  const factory MovieModel({
    required int id,
    required String title,
    @JsonKey(name: 'poster_path') String? posterPath,
    required String overview,
    @JsonKey(name: 'release_date') required String releaseDate,
    @JsonKey(name: 'genre_ids') required List<int> genreIds,
  }) = _MovieModel;

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);
}

extension MovieModelMapper on MovieModel {
  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      posterPath: posterPath ?? '',
      overview: overview,
      releaseDate: releaseDate,
      genreIds: this.genreIds,
    );
  }
}


extension MovieModelToHive on MovieModel {
  MovieHiveModel toHive({String cacheKey = ''}) {
    return MovieHiveModel(
      id: id,
      title: title,
      posterPath: posterPath ?? '',
      overview: overview,
      releaseDate: releaseDate,
      cacheKey: cacheKey,
      genreIds: this.genreIds,
    );
  }
}

