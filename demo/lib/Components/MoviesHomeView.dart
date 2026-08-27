import 'package:demo/Pages/MovieDetails.dart';
import 'package:demo/Pages/moviesData.dart';
import 'package:demo/utils/get_MoviePoster.dart';
import 'package:flutter/material.dart';

Widget homeView(
  AsyncSnapshot<List<dynamic>> snapshot, {
  List<dynamic>? newMovies,
}) {
  final newReleaseMovies = newMovies ?? snapshot.data ?? [];

  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            Text(
              "Features",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: PageView.builder(
                itemCount: featuredMovies.length,
                itemBuilder: (context, index) {
                  final movie = featuredMovies[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(movie["url"]!, fit: BoxFit.cover),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30),

            Text(
              "New",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            SizedBox(
              height: 240,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: newReleaseMovies.length,
                  itemBuilder: (context, index) {
                    final movie = newReleaseMovies[index];

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
                      child: Container(
                        width: 110,
                        margin: EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: getMoviePoster(
                                    movie["poster_path"]!,
                                    110,
                                    160,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  left: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    color: Colors.redAccent,
                                    child: const Text(
                                      'NEW RELEASE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 6),

                            Text(
                              movie["title"]!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 4),

                            Row(
                              children: [
                                Text(
                                  movie["release_date"]!,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),

                                Text(
                                  " • ",
                                  style: TextStyle(color: Colors.grey),
                                ),

                                Icon(Icons.star, color: Colors.amber, size: 14),

                                SizedBox(width: 2),

                                Text(
                                  movie['vote_average'].toStringAsFixed(1),
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Text(
              "Popular",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            SizedBox(
              height: 240,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final movie = snapshot.data![index];

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
                      child: Container(
                        width: 110,
                        margin: EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: getMoviePoster(
                                movie["poster_path"]!,
                                110,
                                160,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              movie["title"]!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 4),

                            Row(
                              children: [
                                Text(
                                  movie["release_date"]!,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),

                                Text(
                                  " • ",
                                  style: TextStyle(color: Colors.grey),
                                ),

                                Icon(Icons.star, color: Colors.amber, size: 14),

                                SizedBox(width: 2),

                                Text(
                                  movie['vote_average'].toStringAsFixed(1),
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
