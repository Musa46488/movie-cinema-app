import 'package:equatable/equatable.dart';
import 'package:movie_app/src/cubit/movie_cubit.dart';
import 'package:movie_app/src/models/movie_model.dart';

const _undefined = Object();

abstract class MoviesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieInitial extends MoviesState {}

class MovieLoading extends MoviesState {}

class MovieLoaded extends MoviesState {
  final List<MoviesModel> allMovies;
  final List<MoviesModel> filteredMovies;
  final int? selectedYear;
  final double? selectedRating;
  final RatingSortOrder sortOrder;

  MovieLoaded({
    required this.allMovies,
    required this.filteredMovies,
    this.selectedYear,
    this.selectedRating,
    this.sortOrder = RatingSortOrder.none,
  });

  @override
  List<Object?> get props => [
    allMovies,
    filteredMovies,
    selectedYear,
    selectedRating,
    sortOrder,
  ];

  MovieLoaded copyWith({
    List<MoviesModel>? allMovies,
    List<MoviesModel>? filteredMovies,
    Object? selectedYear = _undefined,
    Object? selectedRating = _undefined,
    RatingSortOrder? sortOrder,
  }) {
    return MovieLoaded(
      allMovies: allMovies ?? this.allMovies,
      filteredMovies: filteredMovies ?? this.filteredMovies,
      selectedYear: selectedYear == _undefined
          ? this.selectedYear
          : selectedYear as int?,
      selectedRating: selectedRating == _undefined
          ? this.selectedRating
          : selectedRating as double?,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class MovieError extends MoviesState {
  final String message;
  MovieError(this.message);

  @override
  List<Object?> get props => [message];
}
