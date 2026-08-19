import 'package:demo/Pages/MovieDetails.dart';
import 'package:demo/Pages/moviesData.dart';
import 'package:flutter/material.dart';

Widget favoriteView(Set<String> favoriteMovies) {
  final favoriteMovieList = movies.where((movie) {
    return favoriteMovies.contains(movie["name"]);
  }).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [
      Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Favourites",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 10),

      Expanded(
        child: ListView.builder(
          itemCount: favoriteMovieList.length,
          itemBuilder: (context, index) {
            final movie = favoriteMovieList[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetails(
                      name: movie["name"]!,
                      url: movie["url"]!,
                      description: movie["description"]!,
                      year: movie["year"]!,
                      rating: movie["rating"]!,
                      genres: movie["genres"]!,
                      favoriteMovies: favoriteMovies,
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.grey[900],

                child: ListTile(
                  leading: Image.network(
                    movie["url"]!,
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    movie["name"]!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "${movie["year"]} _  ${movie["genres"]}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.favorite, color: Colors.red),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
