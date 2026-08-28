import 'package:demo/Pages/MovieDetails.dart';
import 'package:demo/Providers/FavouriteMoviesProvider.dart';
import 'package:demo/utils/get_MoviePoster.dart';
import 'package:demo/utils/get_gernes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteView extends StatefulWidget {
  final AsyncSnapshot<List<dynamic>> snapshot;
  List<dynamic>? newMovies;

  FavouriteView(this.snapshot, {super.key, this.newMovies});
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

        Consumer<FavouritesProvider>(
          builder: (context, favoriteMoviesData, child) {
            if (favoriteMoviesData.isLoading) {
              return const Expanded(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final favoriteMovieList = [
              ...widget.snapshot.data!.where((movie) {
                return favoriteMoviesData.isFavourite(movie['id'].toString());
              }),
              ...?widget.newMovies?.where((movie) {
                return favoriteMoviesData.isFavourite(movie['id'].toString());
              }),
            ];

            if (favoriteMovieList.isEmpty) {
              return const Expanded(
                child: Center(
                  child: Text(
                    "No Favourites...",
                    style: TextStyle(
                      color: Color.fromARGB(115, 255, 255, 255),
                      fontSize: 25,
                    ),
                  ),
                ),
              );
            }

            return Expanded(
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
                            name: movie["title"]!,
                            url: movie["poster_path"]!,
                            description: movie["overview"]!,
                            year: movie["release_date"]!,
                            rating: movie['vote_average'].toStringAsFixed(1),
                            genres: movie["genre_ids"]!,
                            movie: movie,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        leading: getMoviePoster(movie["poster_path"]!, 50, 70),
                        title: Text(
                          movie["title"]!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          "${movie["release_date"]} _ ${getGenres(movie['genre_ids']).join(' • ')}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            favoriteMoviesData.removeFavourite(
                              movie['id'].toString(),
                            );
                          },
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
