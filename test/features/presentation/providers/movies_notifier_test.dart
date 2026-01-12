import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_apps/features/movies/domain/entities/movie.dart';
import 'package:flutter_apps/features/movies/domain/usecases/get_upcoming_movies.dart';
import 'package:flutter_apps/features/movies/domain/usecases/refresh_upcoming_movies.dart';
import 'package:flutter_apps/features/movies/presentation/providers/movies_provider.dart';

class MockGetUpcomingMovies extends Mock
    implements GetUpcomingMovies {}

class MockRefreshUpcomingMovies extends Mock
    implements RefreshUpcomingMovies {}

void main() {
  late MockGetUpcomingMovies getUpcoming;
  late MockRefreshUpcomingMovies refreshUpcoming;

  ProviderContainer makeContainer() {
    return ProviderContainer(
      overrides: [
        moviesProvider.overrideWith(
              (ref) => MoviesNotifier(
            ref,
            getUpcoming,
            refreshUpcoming,
          ),
        ),
      ],
    );
  }

  setUp(() {
    getUpcoming = MockGetUpcomingMovies();
    refreshUpcoming = MockRefreshUpcomingMovies();
  });

  test('estado inicial é vazio', () {
    when(() => getUpcoming(any()))
        .thenAnswer((_) async => []);

    final container = makeContainer();

    expect(container.read(moviesProvider), []);
  });

  test('fetchNextPage deve atualizar estado', () async {
    when(() => getUpcoming(any()))
        .thenAnswer((_) async => [
      Movie(
        id: 1,
        title: 'Movie',
        posterPath: '',
        overview: '',
        releaseDate: '2025',
        genreIds: const [],
      ),
    ]);

    final container = makeContainer();
    final notifier = container.read(moviesProvider.notifier);

    await notifier.fetchNextPage();

    expect(container.read(moviesProvider).length, 1);
  });

  test('não busca nova página enquanto loading', () async {
    when(() => getUpcoming(any()))
        .thenAnswer((_) async => []);

    final container = makeContainer();
    final notifier = container.read(moviesProvider.notifier);

    notifier.fetchNextPage();
    notifier.fetchNextPage();

    verify(() => getUpcoming(any())).called(1);
  });

  test('refresh reseta pagina para 1', () async {
    when(() => refreshUpcoming(1))
        .thenAnswer((_) async {});

    when(() => getUpcoming(1))
        .thenAnswer((_) async => []);

    final container = makeContainer();
    final notifier = container.read(moviesProvider.notifier);

    await notifier.refresh();

    verify(() => refreshUpcoming(1)).called(1);
  });

  test('refresh retorna updated quando lista muda', () async {
    when(() => refreshUpcoming(1))
        .thenAnswer((_) async {});

    when(() => getUpcoming(1))
        .thenAnswer((_) async => [
      Movie(
        id: 1,
        title: 'Updated Movie',
        posterPath: '',
        overview: '',
        releaseDate: '2025',
        genreIds: const [],
      ),
    ]);

    final container = makeContainer();
    final notifier = container.read(moviesProvider.notifier);

    final result = await notifier.refresh();

    expect(result, RefreshResult.updated);
  });
}