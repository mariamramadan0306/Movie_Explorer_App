import 'package:demo/Providers/FavouriteMoviesProvider.dart';
import 'package:demo/utils/get_MoviePoster.dart';
import 'package:demo/utils/get_gernes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieDetails extends StatefulWidget {
  late String name;
  late String url;
  late String year;
  late String description;
  late String rating;
  late List genres;

  MovieDetails({
    super.key,
    required this.name,
    required this.url,
    required this.year,
    required this.description,
    required this.rating,
    required this.genres,
  });

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(218, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(218, 0, 0, 0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: getMoviePoster(widget.url, 480, 300),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 15,
                vertical: 7,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        widget.year,
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                      Text(
                        "  •  ",
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                      Icon(Icons.star_rate, color: Colors.yellow, size: 15),
                      SizedBox(width: 5),
                      Text(
                        widget.rating,
                        style: TextStyle(color: Colors.yellow, fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    getGenres(widget.genres).join(' • '),
                    style: TextStyle(color: Colors.grey[400], fontSize: 15),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Description",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        widget.description,
                        style: TextStyle(color: Colors.grey[400], fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 77),
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.play_arrow),
                          label: Text(
                            "Watch",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(250, 50),
                            backgroundColor: Colors.purple,
                            iconColor: Colors.white,
                          ),
                        ),
                        Consumer<FavouriteMoviesModel>(
                          builder: (context, favoriteMoviesData, child) =>
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (favoriteMoviesData.favoriteMovies
                                        .contains(widget.name)) {
                                      favoriteMoviesData.favoriteMovies.remove(
                                        widget.name,
                                      );
                                    } else {
                                      favoriteMoviesData.favoriteMovies.add(
                                        widget.name,
                                      );
                                    }
                                  });
                                },
                                icon: Icon(
                                  favoriteMoviesData.favoriteMovies.contains(
                                        widget.name,
                                      )
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      favoriteMoviesData.favoriteMovies
                                          .contains(widget.name)
                                      ? Colors.red
                                      : Colors.white,
                                  size: 30,
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
