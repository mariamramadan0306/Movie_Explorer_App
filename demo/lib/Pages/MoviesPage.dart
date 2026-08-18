import 'package:demo/Pages/MovieDetails.dart';
import 'package:flutter/material.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> featuredMovies = [
      {
        "name": "Inception",
        "url":
            "https://image.tmdb.org/t/p/w780/8ZTVqvKDQ8emSGUEMjsS4yHAwrp.jpg",
      },
      {
        "name": "The Beekeeper",
        "url":
            "https://image.tmdb.org/t/p/w780/4MCKNAc6AbWjEsM2h9Xc29owo4z.jpg",
      },
      {
        "name": "The Dark Knight",
        "url":
            "https://image.tmdb.org/t/p/w780/hZkgoQYus5vegHoetLkCJzb17zJ.jpg",
      },
    ];
    final List<Map<String, String>> movies = [
      {
        "name": "Inception",
        "url":
            "https://image.tmdb.org/t/p/w500/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg",
        "description":
            "A skilled thief who steals secrets through dreams is given a chance to erase his past by planting an idea in someone's mind.",
        "year": "2010",
        "rating": "8.8",
        "genres": "Action • Science Fiction • Drama",
      },
      {
        "name": "Interstellar",
        "url":
            "https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
        "description":
            "A group of astronauts travels through a wormhole in search of a new habitable planet for humanity.",
        "year": "2014",
        "rating": "8.7",
        "genres": "Science Fiction • Drama",
      },
      {
        "name": "The Dark Knight",
        "url":
            "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
        "description":
            "Batman faces his greatest challenge when the chaotic Joker threatens Gotham.",
        "year": "2008",
        "rating": "9.0",
        "genres": "Action • Drama",
      },
      {
        "name": "Avatar",
        "url":
            "https://image.tmdb.org/t/p/w500/kyeqWdyUXW608qlYkRqosgbbJyK.jpg",
        "description":
            "A former Marine becomes part of the Na'vi world on the alien moon Pandora.",
        "year": "2009",
        "rating": "7.9",
        "genres": "Action • Science Fiction • Animation",
      },
      {
        "name": "The Matrix",
        "url":
            "https://image.tmdb.org/t/p/w500/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg",
        "description":
            "A computer hacker discovers that reality is a simulated world controlled by machines.",
        "year": "1999",
        "rating": "8.7",
        "genres": "Action • Science Fiction • Drama",
      },
      {
        "name": "Gladiator",
        "url":
            "https://image.tmdb.org/t/p/w500/ty8TGRuvJLPUmAR1H1nRIsgwvim.jpg",
        "description":
            "A betrayed Roman general becomes a gladiator and fights for revenge against the emperor.",
        "year": "2000",
        "rating": "8.5",
        "genres": "Action • Drama",
      },
    ];
    return Scaffold(
      backgroundColor: const Color.fromARGB(132, 37, 36, 36),

      appBar: AppBar(
        title: Text(
          "Movies Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Column(
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
    );
  }
}

/**
 Inception
Interstellar
The Dark Knight
Avatar
The Matrix
Gladiator 
 */
