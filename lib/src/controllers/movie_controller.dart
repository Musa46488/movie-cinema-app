import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieController {
  static final List<double> ratings = [
    9.0,
    8.0,
    7.0,
    6.0,
    5.0,
    4.0,
    3.0,
    2.0,
    1.0,
  ];
  static List<int> generateYears({int fromYear = 1990}) {
    final currentYear = DateTime.now().year;
    return List.generate(
      currentYear - fromYear + 1,
      (index) => currentYear - index,
    );
  }

  static List<double> moviesRatings() {
    return ratings;
  }

  static Future<void> launchTrailer(
    BuildContext context,
    String trailerUrl,
  ) async {
    final url = Uri.tryParse(trailerUrl);

    if (url != null && await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open trailer')));
    }
  }
}
