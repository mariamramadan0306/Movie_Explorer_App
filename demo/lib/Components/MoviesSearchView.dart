import 'package:demo/Pages/MovieDetails.dart';
import 'package:demo/Pages/moviesData.dart';
import 'package:demo/Providers/FavouriteMoviesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = "";

  void addToFavourite(
    Map<String, String> movie,
    FavouriteMoviesModel favoriteMoviesData,
  ) {
    setState(() {
      if (favoriteMoviesData.favoriteMovies.contains(movie["name"])) {
        favoriteMoviesData.favoriteMovies.remove(movie["name"]);
      } else {
        favoriteMoviesData.favoriteMovies.add(movie["name"]!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredMovies = movies.where((movie) {
      return movie["name"]!.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Search for a movie...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: filteredMovies.length,
            itemBuilder: (context, index) {
              final movie = filteredMovies[index];

              return Consumer<FavouriteMoviesModel>(
                builder: (context, favoriteMoviesData, child) =>
                    GestureDetector(
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
                          trailing: IconButton(
                            onPressed: () {
                              addToFavourite(movie, favoriteMoviesData);
                            },
                            icon: Icon(
                              favoriteMoviesData.favoriteMovies.contains(
                                    movie["name"],
                                  )
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  favoriteMoviesData.favoriteMovies.contains(
                                    movie["name"],
                                  )
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
              );
            },
          ),
        ),
      ],
    );
  }
}
