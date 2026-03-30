import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/screens/movie_detail_screen.dart';
import 'package:movie_app/src/widgets/movie_filter_widget.dart';

import '../cubit/movie_cubit.dart';
import '../cubit/movie_state_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoviesCubit()..fetchMovies(),
      child: Scaffold(
        appBar: AppBar(title: Text("Top 250 Movies")),
        body: BlocBuilder<MoviesCubit, MoviesState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MovieLoaded) {
              final movies = state.filteredMovies;
              return Column(
                children: [
                  MovieFilters(),
                  if (movies.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          'No Movie Found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      MovieDetailScreen(movie: movie),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      movie.image,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  movie.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Rating ⭐: ${movie.averageRating}'),
                                Text('Duration: ${movie.runtimeMinutes} mins'),
                                Text('Release: ${movie.releaseDate}'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            } else if (state is MovieError) {
              return Center(child: Text(state.message));
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
