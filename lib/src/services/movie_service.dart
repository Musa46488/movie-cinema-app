import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app/src/models/movie_model.dart';

class MoviesApiService {
  static const String _apiKey =
      'bb959f44aemshc6a8811dd2944e1p1bf95ajsnc1ce5b223b1c';
  static const String _apiHost = 'imdb236.p.rapidapi.com';
  static const String _baseUrl =
      'https://imdb236.p.rapidapi.com/api/imdb/top250-movies';

  static Future<List<MoviesModel>> fetchTop250Movies() async {
    final uri = Uri.parse(_baseUrl);

    final response = await http.get(
      uri,
      headers: {'X-RapidAPI-Key': _apiKey, 'X-RapidAPI-Host': _apiHost},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => MoviesModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top 250 movies: ${response.statusCode}');
    }
  }
}
