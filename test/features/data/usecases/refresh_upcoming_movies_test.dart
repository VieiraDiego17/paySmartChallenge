import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_apps/features/movies/domain/repositories/movies_repository.dart';
import 'package:flutter_apps/features/movies/domain/usecases/refresh_upcoming_movies.dart';

class MockMoviesRepository extends Mock
    implements MoviesRepository {}

void main() {
  late MockMoviesRepository repository;
  late RefreshUpcomingMovies usecase;

  setUp(() {
    repository = MockMoviesRepository();
    usecase = RefreshUpcomingMovies(repository);
  });

  test('deve chamar refreshUpcoming no repository', () async {
    // arrange
    when(() => repository.refreshUpcoming(1))
        .thenAnswer((_) async {});

    // act
    await usecase(1);

    // assert
    verify(() => repository.refreshUpcoming(1)).called(1);
  });

  test('chama refreshUpcoming do repository', () async {
    when(() => repository.refreshUpcoming(1))
        .thenAnswer((_) async {});

    await usecase(1);

    verify(() => repository.refreshUpcoming(1)).called(1);
  });

}
