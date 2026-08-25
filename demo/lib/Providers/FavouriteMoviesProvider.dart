import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteMoviesModel extends ChangeNotifier {
  List<Map<String, dynamic>> favoriteMovies = [];

  FavouriteMoviesModel() {
    loadFavorites();
  }

  Future<void> addFavourite(Map<String, dynamic> movie) async {
    favoriteMovies.add(movie);

    await saveFavorites();

    notifyListeners();
  }

  Future<void> removeFavourite(Map<String, dynamic> movie) async {
    favoriteMovies.removeWhere((m) => m['id'] == movie['id']);

    await saveFavorites();

    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('favoriteMovies', jsonEncode(favoriteMovies));
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('favoriteMovies');

    if (data != null) {
      favoriteMovies = List<Map<String, dynamic>>.from(jsonDecode(data));
    }

    notifyListeners();
  }
}
