import 'package:demo/Pages/MovieDetails.dart';
import 'package:demo/Providers/FavouriteMoviesProvider.dart';
import 'package:demo/utils/get_MoviePoster.dart';
import 'package:demo/utils/get_gernes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteView extends StatefulWidget {
  AsyncSnapshot<List<dynamic>> snapshot;
  FavouriteView(this.snapshot, {super.key});
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
                      final favoriteMovieList = widget.snapshot.data!.where((
                        movie,
                      ) {
                        return favoriteMoviesData.favoriteMovies.any(
                          (favorite) => favorite['id'] == movie['id'],
                        );
                      }).toList();
                      final movie = favoriteMovieList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetails(
                                name: movie["title"]!,
                                url: movie["poster_path"]!,
                                description: movie["overview"]!,
                                year: movie["release_date"]!,
                                rating: movie['vote_average'].toStringAsFixed(
                                  1,
                                ),
                                genres: movie["genre_ids"]!,
                                movie: movie,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.grey[900],

                          child: ListTile(
                            leading: getMoviePoster(
                              movie["poster_path"]!,
                              50,
                              70,
                            ),
                            title: Text(
                              movie["title"]!,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "${movie["release_date"]} _   ${getGenres(movie['genre_ids']).join(' • ')}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  favoriteMoviesData.removeFavourite(movie);
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
