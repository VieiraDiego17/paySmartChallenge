import 'package:go_router/go_router.dart';
import '../../features/movies/domain/entities/movie.dart';
import '../../features/movies/presentation/pages/movie_detail_page.dart';
import '../../features/movies/presentation/pages/movies_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MoviesPage(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) {
        final movie = state.extra as Movie;
        return MovieDetailsPage(movie: movie);
      },
    ),
  ],
);
