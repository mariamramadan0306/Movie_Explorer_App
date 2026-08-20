import 'package:demo/Pages/MovieDetails.dart';
import 'package:demo/Pages/moviesData.dart';
import 'package:demo/Providers/FavouriteMoviesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteView extends StatefulWidget {
  FavouriteView({super.key});
  @override
  State<FavouriteView> createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
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

        Consumer<FavouriteMoviesModel>(
          builder: (context, favoriteMoviesData, child) => Expanded(
            child: favoriteMoviesData.favoriteMovies.isEmpty
                ? Center(
                    child: Text(
                      "No Favourites...",
                      style: TextStyle(
                        color: const Color.fromARGB(115, 255, 255, 255),
                        fontSize: 25,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: favoriteMoviesData.favoriteMovies.length,
                    itemBuilder: (context, index) {
                      final favoriteMovieList = movies.where((movie) {
                        return favoriteMoviesData.favoriteMovies.contains(
                          movie["name"],
                        );
                      }).toList();
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
                                setState(() {
                                  favoriteMoviesData.favoriteMovies.remove(
                                    movie["name"],
                                  );
                                });
                              },
                              icon: Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
