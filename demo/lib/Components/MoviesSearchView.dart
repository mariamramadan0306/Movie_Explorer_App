import 'package:demo/Pages/MovieDetails.dart';
import 'package:demo/Providers/FavouriteMoviesProvider.dart';
import 'package:demo/utils/get_MoviePoster.dart';
import 'package:demo/utils/get_gernes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final AsyncSnapshot<List<dynamic>> snapshot;
  final VoidCallback onOpenChat;
  final int? selectedGenreId;
  List<dynamic>? newMovies;
  SearchPage(
    this.snapshot, {
    required this.onOpenChat,
    super.key,
    this.newMovies,
    this.selectedGenreId,
  });
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = "";

  Future<void> addToFavourite(
    Map<String, dynamic> movie,
    FavouritesProvider favoriteMoviesData,
  ) async {
    final movieId = movie['id'].toString();
    final isFavorite = favoriteMoviesData.isFavourite(movieId);

    if (isFavorite) {
      await favoriteMoviesData.removeFavourite(movieId);
    } else {
      await favoriteMoviesData.addFavourite(movieId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseMovies = [
      ...(widget.newMovies ?? []),
      ...(widget.snapshot.data ?? []),
    ];

    final filteredMovies = baseMovies.where((movie) {
      final matchesTitle = movie["title"]!.toString().toLowerCase().contains(
        searchText.toLowerCase(),
      );

      final matchesGenre =
          widget.selectedGenreId == null ||
          ((movie['genre_ids'] ?? []) as List)
              .map((id) => id is int ? id : int.tryParse(id.toString()))
              .whereType<int>()
              .contains(widget.selectedGenreId);

      return matchesTitle && matchesGenre;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
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
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: 'Open movie chatbot',
                onPressed: widget.onOpenChat,
                icon: const Icon(Icons.smart_toy_outlined),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: filteredMovies.length,
            itemBuilder: (context, index) {
              final movie = filteredMovies[index];

              return Consumer<FavouritesProvider>(
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
                          favoriteMoviesData.isFavourite(movie['id'].toString())
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              favoriteMoviesData.isFavourite(
                                movie['id'].toString(),
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
