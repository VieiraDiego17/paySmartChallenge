import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_apps/features/movies/domain/entities/movie.dart';
import 'package:flutter_apps/features/movies/domain/repositories/movies_repository.dart';
import 'package:flutter_apps/features/movies/domain/usecases/get_upcoming_movies.dart';

class MockMoviesRepository extends Mock
    implements MoviesRepository {}

void main() {
  late MockMoviesRepository repository;
  late GetUpcomingMovies usecase;

  setUp(() {
    repository = MockMoviesRepository();
    usecase = GetUpcomingMovies(repository);
  });

  final moviesMock = [
    Movie(
      id: 1,
      title: 'Movie 1',
      posterPath: '',
      overview: '',
      releaseDate: '2025-01-01',
      genreIds: const [28, 12],
    ),
  ];

  test('deve retornar lista de filmes do repository', () async {
    when(() => repository.getUpcomingMovies(1))
        .thenAnswer((_) async => moviesMock);

    final result = await usecase(1);

    expect(result, moviesMock);
    verify(() => repository.getUpcomingMovies(1)).called(1);
  });

  test('delegates call to repository', () async {
    when(() => repository.getUpcomingMovies(1))
        .thenAnswer((_) async => []);

    await usecase(1);

    verify(() => repository.getUpcomingMovies(1)).called(1);
  });

}
