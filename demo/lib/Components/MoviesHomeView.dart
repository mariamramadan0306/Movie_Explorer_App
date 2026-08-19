import 'package:demo/Pages/MovieDetails.dart';
import 'package:demo/Pages/moviesData.dart';
import 'package:flutter/material.dart';

Widget homeView(Set<String> favoriteMovies) {
  return Column(
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
            height: 250,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];

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
                    child: Container(
                      width: 110,
                      margin: EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              movie["url"]!,
                              width: 110,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            movie["name"]!,
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
                                movie["year"]!,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),

                              Text(" • ", style: TextStyle(color: Colors.grey)),

                              Icon(Icons.star, color: Colors.amber, size: 14),

                              SizedBox(width: 2),

                              Text(
                                movie["rating"]!,
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
  );
}
