import 'package:demo/Pages/MoviesPage.dart';
import 'package:demo/utils/fetch_Movies.dart';
import 'package:demo/utils/get_gernes.dart';
import 'package:flutter/material.dart';

class GenresPage extends StatelessWidget {
  const GenresPage({super.key});

  final List<LinearGradient> _genreGradients = const [
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF7B2FF7), Color(0xFF2D1B69)],
      stops: [0.0, 1.0],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
      stops: [0.0, 1.0],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFF7A18), Color(0xFFEA2C62)],
      stops: [0.0, 1.0],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
      stops: [0.0, 1.0],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
      stops: [0.0, 1.0],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF6D365), Color(0xFFFDA085)],
      stops: [0.0, 1.0],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFB721FF), Color(0xFF21D4FD)],
      stops: [0.0, 1.0],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF00F5A0), Color(0xFF00D9F5)],
      stops: [0.0, 1.0],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final genres = genreNames.entries.toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(218, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(218, 0, 0, 0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Genres',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List>(
        future: fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text(
                'Unable to load genres',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final movieList = snapshot.data ?? const [];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: genres.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final entry = genres[index];
                final genreId = entry.key;
                final genreName = entry.value;

                final genreMovies = movieList.where((movie) {
                  final ids = ((movie['genre_ids'] ?? []) as List)
                      .map((id) => id is int ? id : int.tryParse(id.toString()))
                      .whereType<int>()
                      .toList();
                  return ids.contains(genreId);
                }).toList();

                final displayedMovies = genreMovies.take(3).map((movie) {
                  final title = movie['title']?.toString() ?? 'Unknown';
                  return Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  );
                }).toList();

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MoviesPage(
                          selectedGenreId: genreId,
                          selectedGenreName: genreName,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: _genreGradients[index % _genreGradients.length],
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 12,
                          left: 12,
                          right: 12,
                          child: Text(
                            genreName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 48,
                          left: 12,
                          right: 12,
                          bottom: 42,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (displayedMovies.isNotEmpty)
                                ...displayedMovies
                              else
                                const Text(
                                  'No movies yet',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Text(
                              '${genreMovies.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
