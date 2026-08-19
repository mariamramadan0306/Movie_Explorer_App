import 'package:demo/Pages/MovieDetails.dart';
import 'package:demo/Pages/moviesData.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  Set<String> favoriteMovies;
  SearchPage({super.key, required this.favoriteMovies});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = "";

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
                        favoriteMovies: widget.favoriteMovies,
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
                          if (widget.favoriteMovies.contains(movie["name"])) {
                            widget.favoriteMovies.remove(movie["name"]);
                          } else {
                            widget.favoriteMovies.add(movie["name"]!);
                          }
                        });
                      },
                      icon: Icon(
                        widget.favoriteMovies.contains(movie["name"])
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.favoriteMovies.contains(movie["name"])
                            ? Colors.red
                            : Colors.white,
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
