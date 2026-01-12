import 'package:flutter_apps/features/movies/data/models/movie_hive_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_apps/features/movies/data/repositories/movies_repository_impl.dart';
import 'package:flutter_apps/features/movies/data/datasources/movies_remote_datasource.dart';
import 'package:flutter_apps/features/movies/data/datasources/movies_local_datasource.dart';
import 'package:flutter_apps/features/movies/data/models/movie_model.dart';

class MockRemoteDatasource extends Mock
    implements MoviesRemoteDatasource {}

class MockLocalDatasource extends Mock
    implements MoviesLocalDatasource {}

void main() {
  late MoviesRepositoryImpl repository;
  late MockRemoteDatasource remote;
  late MockLocalDatasource local;

  final movieModels = [
    MovieModel(
      id: 1,
      title: 'Movie',
      posterPath: '/poster.jpg',
      overview: 'overview',
      releaseDate: '2025-01-01',
      genreIds: [28],
    ),
  ];

  final cachedHiveMovies = [
    MovieHiveModel(
      id: 1,
      title: 'Cached Movie',
      posterPath: '/cached.jpg',
      overview: 'cached overview',
      releaseDate: '2024-01-01',
      cacheKey: 'upcoming_page_1',
      genreIds: [12],
    ),
  ];

  setUp(() {
    remote = MockRemoteDatasource();
    local = MockLocalDatasource();

    repository = MoviesRepositoryImpl(
      remote: remote,
      local: local,
    );
  });

  test('deve buscar do remoto e salvar no cache quando não houver cache', () async {
    // arrange
    const page = 1;
    const cacheKey = 'upcoming_page_1';

    when(() => local.getMovies(cacheKey))
        .thenAnswer((_) async => null);

    when(() => remote.getUpcomingMovies(page))
        .thenAnswer((_) async => movieModels);

    when(() => local.saveMovies(any(), any()))
        .thenAnswer((_) async {});

    // act
    final result = await repository.getUpcomingMovies(page);

    // assert
    expect(result.length, 1);

    verify(() => local.getMovies(cacheKey)).called(1);
    verify(() => remote.getUpcomingMovies(page)).called(1);
    verify(() => local.saveMovies(any(), any())).called(1);
  });

  test('quando cache existe mas está vazio, busca do remoto', () async {
    when(() => local.getMovies(any()))
        .thenAnswer((_) async => []);

    when(() => remote.getUpcomingMovies(any()))
        .thenAnswer((_) async => movieModels);

    when(() => local.saveMovies(any(), any()))
        .thenAnswer((_) async {});

    final result = await repository.getUpcomingMovies(1);

    expect(result.isNotEmpty, true);
  });

  test('não quebra quando refresh remoto falha', () async {
    when(() => local.getMovies(any()))
        .thenAnswer((_) async => cachedHiveMovies);

    when(() => remote.getUpcomingMovies(any()))
        .thenThrow(Exception());

    final result = await repository.getUpcomingMovies(1);

    expect(result.isNotEmpty, true);
  });



}
