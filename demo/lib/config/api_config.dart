import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get tmdbToken => dotenv.env['TMDB_READ_ACCESS_TOKEN'] ?? '';

  static String get huggingFaceApiKey => dotenv.env['HF_API_KEY'] ?? '';

  static String get googleClientKey => dotenv.env['CLIENT_ID'] ?? '';
}
