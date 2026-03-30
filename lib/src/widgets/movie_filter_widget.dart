import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/cubit/movie_cubit.dart';
import 'package:movie_app/src/cubit/movie_state_cubit.dart';

class MovieFilters extends StatelessWidget {
  final List<int> years = MovieController.generateYears();
  final ratings = MovieController.moviesRatings();

  MovieFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesCubit, MoviesState>(
      builder: (context, state) {
        if (state is! MovieLoaded) return SizedBox.shrink();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              _buildFilterChip(
                context: context,
                label: 'Year',
                value: state.selectedYear?.toString() ?? 'Any',
                onTap: () => _showYearSelector(context, state),
              ),
              SizedBox(width: 12),
              _buildFilterChip(
                context: context,
                label: 'Rating',
                value: state.selectedRating?.toStringAsFixed(1) ?? 'Any',
                onTap: () => _showRatingSelector(context, state),
              ),
              SizedBox(width: 12),
              _buildFilterChip(
                context: context,
                label: 'Sort',
                value: _sortLabel(state.sortOrder),
                onTap: () => _showSortSelector(context, state),
              ),
              SizedBox(width: 12),
              _buildResetChip(context),
            ],
          ),
        );
      },
    );
  }

  void _showSortSelector(BuildContext context, MovieLoaded state) {
    showDialog(
      context: context,
      builder: (_) {
        RatingSortOrder selected = state.sortOrder;

        return AlertDialog(
          title: Text("Sort by Rating"),
          content: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: RatingSortOrder.values.map((order) {
                return RadioListTile<RatingSortOrder>(
                  title: Text(_sortLabel(order)),
                  value: order,
                  groupValue: selected,
                  onChanged: (value) {
                    setState(() => selected = value!);
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Apply"),
              onPressed: () {
                Navigator.pop(context);
                context.read<MoviesCubit>().filterMovies(
                  year: state.selectedYear,
                  minRating: state.selectedRating,
                  sortOrder: selected,
                );
              },
            ),
          ],
        );
      },
    );
  }

  String _sortLabel(RatingSortOrder order) {
    switch (order) {
      case RatingSortOrder.highestToLowest:
        return 'High → Low';
      case RatingSortOrder.lowestToHighest:
        return 'Low → High';
      default:
        return 'None';
    }
  }

  Widget _buildResetChip(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<MoviesCubit>().resetFilters(),
      child: Chip(
        label: Text("Reset Filters"),
        backgroundColor: Colors.red.shade100,
        labelStyle: TextStyle(color: Colors.red.shade800),
        shape: StadiumBorder(),
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text("$label: $value", style: TextStyle(color: Colors.white)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: StadiumBorder(),
        backgroundColor: Colors.grey.shade800,
      ),
    );
  }

  void _showYearSelector(BuildContext context, MovieLoaded state) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Year",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildYearChip(context, null, state),
                  ...years.map((year) => _buildYearChip(context, year, state)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearChip(BuildContext context, int? year, MovieLoaded state) {
    final isSelected = year == state.selectedYear;
    return ChoiceChip(
      label: Text(
        year?.toString() ?? "Any",
        style: TextStyle(color: Colors.white),
      ),
      selected: isSelected,
      selectedColor: Colors.blue,
      onSelected: (_) {
        Navigator.pop(context);
        context.read<MoviesCubit>().filterMovies(
          year: year,
          minRating: state.selectedRating,
        );
      },
    );
  }

  void _showRatingSelector(BuildContext context, MovieLoaded state) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Select Minimum Rating",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildRatingChip(context, null, state),
                ...ratings.map(
                  (rating) => _buildRatingChip(context, rating, state),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingChip(
    BuildContext context,
    double? rating,
    MovieLoaded state,
  ) {
    final isSelected = rating == state.selectedRating;
    final label = rating != null ? '${rating.toStringAsFixed(1)} ⭐' : 'Any';
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: Colors.white)),
      selected: isSelected,
      selectedColor: Colors.blue,
      onSelected: (_) {
        Navigator.pop(context);
        context.read<MoviesCubit>().filterMovies(
          year: state.selectedYear,
          minRating: rating,
        );
      },
    );
  }
}
