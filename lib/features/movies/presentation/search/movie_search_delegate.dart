import 'package:flutter/material.dart';
import 'package:flutter_apps/features/movies/presentation/widget/movie_poster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/movie.dart';
import '../providers/search_movies_provider.dart';

class MovieSearchDelegate extends SearchDelegate<Movie?> {
  @override
  String get searchFieldLabel => 'Buscar filmes';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _SearchResults(
      query: query,
      onMovieSelected: (movie) {
        close(context, movie);
        context.push('/details', extra: movie);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length < 2) {
      return const Center(
        child: Text('Digite ao menos 2 caracteres'),
      );
    }

    return _SearchResults(
      query: query,
      onMovieSelected: (movie) {
        close(context, movie);
        context.push('/details', extra: movie);
      },
    );
  }
}

class _SearchResults extends ConsumerStatefulWidget {
  final String query;
  final void Function(Movie movie) onMovieSelected;

  const _SearchResults({
    required this.query,
    required this.onMovieSelected,
  });

  @override
  ConsumerState<_SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends ConsumerState<_SearchResults> {
  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  void didUpdateWidget(covariant _SearchResults oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.query != widget.query) {
      _search();
    }
  }

  void _search() {
    ref
        .read(searchMoviesProvider.notifier)
        .search(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchMoviesProvider);

    return state.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => Center(
        child: Text('Erro ao buscar filmes'),
      ),
      data: (movies) {
        if (movies.isEmpty) {
          return const Center(
            child: Text('Nenhum filme encontrado'),
          );
        }

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];

            if (index == movies.length - 1) {
              ref
                  .read(searchMoviesProvider.notifier)
                  .fetchNextPage();
            }

            return ListTile(
              // leading: movie.posterPath.isNotEmpty
              //     ? Image.network(
              //   '${ApiConstants.imageBaseUrl}${movie.posterPath}',
              //   width: 50,
              //   fit: BoxFit.cover,
              //   loadingBuilder: (context, child, loadingProgress) {
              //     if (loadingProgress == null) return child;
              //     return const SizedBox(
              //       width: 50,
              //       height: 75,
              //       child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              //     );
              //   },
              //   errorBuilder: (context, error, stackTrace) {
              //     return const SizedBox(
              //       width: 50,
              //       height: 75,
              //       child: Center(child: Icon(Icons.broken_image, size: 28)),
              //     );
              //   },
              // )
              //     : const SizedBox(width: 50),
              leading: MoviePoster(
                posterPath: movie.posterPath,
              ),
              title: Text(movie.title),
              subtitle: Text(movie.releaseDate),
              onTap: () => widget.onMovieSelected(movie),
            );
          },
        );
      },
    );
  }
}

