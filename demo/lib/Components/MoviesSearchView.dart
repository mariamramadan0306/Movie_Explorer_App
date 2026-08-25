import 'package:demo/Pages/MovieDetails.dart';
import 'package:demo/Providers/FavouriteMoviesProvider.dart';
import 'package:demo/utils/get_MoviePoster.dart';
import 'package:demo/utils/get_gernes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  AsyncSnapshot<List<dynamic>> snapshot;
  SearchPage(this.snapshot, {super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = "";

  void addToFavourite(
    Map<String, dynamic> movie,
    FavouriteMoviesModel favoriteMoviesData,
  ) {
    final isFavorite = favoriteMoviesData.favoriteMovies.any(
      (favorite) => favorite['id'] == movie['id'],
    );

    if (isFavorite) {
      favoriteMoviesData.removeFavourite(movie);
    } else {
      favoriteMoviesData.addFavourite(movie);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredMovies = widget.snapshot.data!.where((movie) {
      return movie["title"]!.toLowerCase().contains(searchText.toLowerCase());
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
                builder: (context, favoriteMoviesData, child) => GestureDetector(
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
                        "${movie["release_date"]} _  ${getGenres(movie['genre_ids']).join(' • ')}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          addToFavourite(movie, favoriteMoviesData);
                        },
                        icon: Icon(
                          favoriteMoviesData.favoriteMovies.any(
                                (favorite) => favorite['id'] == movie['id'],
                              )
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              favoriteMoviesData.favoriteMovies.any(
                                (favorite) => favorite['id'] == movie['id'],
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
