import 'package:flutter/material.dart';
import 'package:flutter_apps/core/constants/movie_genres.dart';
import 'package:flutter_apps/features/movies/domain/entities/movie.dart';
import 'package:flutter_apps/features/movies/presentation/widget/movie_poster.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: MoviePoster(
                posterPath: movie.posterPath,
                width: 200,
                height: 300,
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              movie.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 8),

            Text(
              'Lançamento: ${movie.releaseDate}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: movie.genreIds
                  .map(
                    (id) => Chip(
                  label: Text(movieGenres[id] ?? 'Desconhecido'),
                ),
              )
                  .toList(),
            ),

            const SizedBox(height: 16),

            Text(
              movie.overview,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

