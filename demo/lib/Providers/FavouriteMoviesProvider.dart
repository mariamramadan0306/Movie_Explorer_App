import 'package:flutter/material.dart';

class FavouriteMoviesModel extends ChangeNotifier {
  Set<String> favoriteMovies = {};
  void addToFavourite(String product) {
    favoriteMovies.add(product);
    notifyListeners();
  }
}
