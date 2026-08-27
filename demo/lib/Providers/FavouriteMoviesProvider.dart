import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FavouritesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String userId;

  FavouritesProvider(this.userId);

  List<Map<String, dynamic>> _favourites = [];
  bool _isLoading = true;
  String? _error;

  StreamSubscription<QuerySnapshot>? _favouritesSubscription;

  List<Map<String, dynamic>> get favourites => _favourites;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CollectionReference<Map<String, dynamic>> get favouritesCollection {
    return _firestore.collection("users").doc(userId).collection("favourites");
  }

  void startListening() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _favouritesSubscription?.cancel();

    _favouritesSubscription = favouritesCollection.snapshots().listen(
      (snapshot) {
        _favourites = snapshot.docs.map((doc) {
          return {'id': doc.id, ...doc.data()};
        }).toList();

        _isLoading = false;
        _error = null;

        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _error = error.toString();

        notifyListeners();
      },
    );
  }

  Future<void> addFavourite(String movieId) async {
    await favouritesCollection.doc(movieId).set({
      'movie_id': movieId,
      'added_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFavourite(String movieId) async {
    await favouritesCollection.doc(movieId).delete();
  }

  bool isFavourite(String movieId) {
    return _favourites.any((favourite) => favourite['movie_id'] == movieId);
  }

  @override
  void dispose() {
    _favouritesSubscription?.cancel();
    super.dispose();
  }
}
