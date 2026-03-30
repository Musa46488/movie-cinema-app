import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/cubit/movie_state_cubit.dart';
import 'package:movie_app/src/services/movie_service.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit() : super(MovieInitial());

  void fetchMovies() async {
    emit(MovieLoading());
    try {
      final movies = await MoviesApiService.fetchTop250Movies();
      emit(MovieLoaded(allMovies: movies, filteredMovies: movies));
    } catch (e) {
      emit(MovieError("Failed to fetch movies. Please try again later."));
      debugPrint('Error fetching movies: $e');
    }
  }

  void filterMovies({
    int? year,
    double? minRating,
    RatingSortOrder? sortOrder,
  }) {
    if (state is! MovieLoaded) return;
    final currentState = state as MovieLoaded;

    final filtered = currentState.allMovies.where((movie) {
      final matchesYear =
          year == null || movie.releaseDate.startsWith(year.toString());
      final matchesRating =
          minRating == null || movie.averageRating >= minRating;
      return matchesYear && matchesRating;
    }).toList();
    final activeSortOrder = sortOrder ?? currentState.sortOrder;
    if (activeSortOrder == RatingSortOrder.highestToLowest) {
      filtered.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    } else if (activeSortOrder == RatingSortOrder.lowestToHighest) {
      filtered.sort((a, b) => a.averageRating.compareTo(b.averageRating));
    }
    emit(
      currentState.copyWith(
        filteredMovies: filtered,
        selectedYear: year,
        selectedRating: minRating ?? currentState.selectedRating,
        sortOrder: activeSortOrder,
      ),
    );
  }

  void applyCurrentFilters() {
    if (state is! MovieLoaded) return;
    final currentState = state as MovieLoaded;
    filterMovies(
      year: currentState.selectedYear,
      minRating: currentState.selectedRating,
      sortOrder: currentState.sortOrder,
    );
  }

  void resetFilters() {
    if (state is! MovieLoaded) return;
    final currentState = state as MovieLoaded;
    emit(
      currentState.copyWith(
        filteredMovies: currentState.allMovies,
        selectedYear: null,
        selectedRating: null,
        sortOrder: RatingSortOrder.none,
      ),
    );
  }
}

enum RatingSortOrder { none, highestToLowest, lowestToHighest }
