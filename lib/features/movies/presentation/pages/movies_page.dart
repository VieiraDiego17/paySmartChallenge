import 'package:flutter/material.dart';
import 'package:flutter_apps/core/constants/movie_genres.dart';
import 'package:flutter_apps/features/movies/presentation/search/movie_search_delegate.dart';
import 'package:flutter_apps/features/movies/presentation/widget/movie_card.dart';
import 'package:flutter_apps/features/movies/presentation/widget/movie_poster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/movies_provider.dart';

class MoviesPage extends ConsumerWidget {
  const MoviesPage({super.key});

  String genresFromIds(List<int> ids) {
    return ids
        .map((id) => movieGenres[id])
        .whereType<String>()
        .join(', ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(moviesProvider);
    final isRefreshing = ref.watch(moviesRefreshingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Próximos Filmes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: isRefreshing
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.refresh),
            onPressed: isRefreshing
                ? null
                : () async {
              final result =
              await ref.read(moviesProvider.notifier).refresh();

              if (!context.mounted) return;

              final message = switch (result) {
                RefreshResult.updated =>
                'Lista atualizada',
                RefreshResult.noChanges =>
                'Lista já está atualizada',
                RefreshResult.error =>
                'Erro ao atualizar lista',
              };

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final result =
          await ref.read(moviesProvider.notifier).refresh();

          if (!context.mounted) return;

          final message = switch (result) {
            RefreshResult.updated =>
            'Lista atualizada',
            RefreshResult.noChanges =>
            'Lista já está atualizada',
            RefreshResult.error =>
            'Erro ao atualizar lista',
          };

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
        child: movies.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];

            if (index == movies.length - 1) {
              ref
                  .read(moviesProvider.notifier)
                  .fetchNextPage();
            }

            return MovieCard(
              movie: movie,
              genres: genresFromIds(movie.genreIds),
            );
          },
        ),
      ),
    );
  }
}
