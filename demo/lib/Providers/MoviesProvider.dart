import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MoviesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _movies = [];
  bool _isLoading = true;
  String? _error;

  StreamSubscription<QuerySnapshot>? _moviesSubscription;

  List<Map<String, dynamic>> get movies => _movies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void startListening() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _moviesSubscription?.cancel();

    _moviesSubscription = _firestore
        .collection('movies')
        .snapshots()
        .listen(
          (snapshot) {
            _movies = snapshot.docs.map((doc) {
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

  @override
  void dispose() {
    _moviesSubscription?.cancel();
    super.dispose();
  }
}
