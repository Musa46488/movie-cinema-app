import 'package:flutter/material.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';

import '../models/movie_model.dart';

class MovieDetailScreen extends StatelessWidget {
  final MoviesModel movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                movie.image,
                height: 500,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '${movie.title} (${movie.startYear})',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 4),
            Text(
              movie.originalTitle != movie.title ? movie.originalTitle : '',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                SizedBox(width: 4),
                Text('${movie.averageRating}/10'),
                SizedBox(width: 16),
                Text('D: ${movie.runtimeMinutes} min'),
                SizedBox(width: 16),
                Text('Rated: ${movie.contentRating}'),
              ],
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 4,
              children: movie.genres
                  .map(
                    (genre) => Chip(
                      label: Text(genre, style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.grey.shade800,
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 16),
            Text(movie.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            if (movie.productionCompany != null)
              Text(
                'Produced by: ${movie.productionCompany}',
                style: TextStyle(color: Colors.grey),
              ),
            SizedBox(height: 16),
            if (movie.trailer.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    MovieController.launchTrailer(context, movie.trailer);
                  },
                  label: Text('Watch Trailer'),
                  icon: Icon(Icons.play_arrow),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
