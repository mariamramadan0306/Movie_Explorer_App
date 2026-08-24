import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:demo/config/api_config.dart';

Future<List> fetchMovies() async {
  final response = await http.get(
    Uri.parse('https://api.themoviedb.org/3/movie/popular'),
    headers: {
      'Authorization': 'Bearer ${ApiConfig.tmdbToken}',
      'accept': 'application/json',
    },
  );
  final data = jsonDecode(response.body);
  final movies = data['results'];

  return movies;
}
