import 'package:flutter/material.dart';

Widget getMoviePoster(String? posterPath, double width, double height) {
  if (posterPath != null && posterPath.isNotEmpty) {
    return Image.network(
      'https://image.tmdb.org/t/p/w500$posterPath',
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }

  return const Icon(Icons.movie, size: 15);
}
