import 'package:flutter/material.dart';
import '../../../../core/constants/api_constants.dart';

class MoviePoster extends StatelessWidget {
  final String posterPath;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const MoviePoster({
    super.key,
    required this.posterPath,
    this.width = 50,
    this.height = 75,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (posterPath.isEmpty) {
      return _placeholder();
    }
//teste
    final imageUrl = '${ApiConstants.imageBaseUrl}$posterPath';

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: width,
            height: height,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _placeholder();
        },
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade800,
      child: const Icon(
        Icons.movie,
        size: 32,
        color: Colors.white70,
      ),
    );
  }
}
