
import 'package:hive/hive.dart';
import '../../domain/entities/movie.dart';

part 'movie_hive_model.g.dart';

@HiveType(typeId: 0)
class MovieHiveModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String posterPath;

  @HiveField(3)
  final String overview;

  @HiveField(4)
  final String releaseDate;

  @HiveField(5)
  final String cacheKey;

  @HiveField(6)
  final List<int> genreIds;

  MovieHiveModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.releaseDate,
    required this.cacheKey,
    required this.genreIds,
  });

  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      posterPath: posterPath,
      overview: overview,
      releaseDate: releaseDate,
      genreIds: genreIds,
    );
  }
}

