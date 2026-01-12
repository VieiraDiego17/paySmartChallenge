class MovieCacheModel {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;
  final String genreIds;

  MovieCacheModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required  this.genreIds
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'releaseDate': releaseDate,
    };
  }

  factory MovieCacheModel.fromMap(Map<String, dynamic> map) {
    return MovieCacheModel(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'],
      releaseDate: map['releaseDate'],
      genreIds: map['genreIds'],
    );
  }
}
