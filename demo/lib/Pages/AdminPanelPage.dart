import 'package:demo/Providers/MoviesProvider.dart';
import 'package:demo/utils/get_MoviePoster.dart';
import 'package:demo/utils/get_gernes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  static Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  Future<Map<String, dynamic>?> _showMovieDialog(
    BuildContext context, {
    Map<String, dynamic>? movie,
  }) async {
    final titleController = TextEditingController(
      text: movie?['title']?.toString() ?? '',
    );
    final posterController = TextEditingController(
      text: movie?['poster_path']?.toString() ?? '',
    );
    final overviewController = TextEditingController(
      text: movie?['overview']?.toString() ?? '',
    );
    final releaseDateController = TextEditingController(
      text: movie?['release_date']?.toString() ?? '',
    );
    final ratingController = TextEditingController(
      text: movie?['vote_average']?.toString() ?? '0',
    );
    final selectedGenreIds = ((movie?['genre_ids'] as List<dynamic>?) ?? [])
        .map(
          (genreId) => genreId is num
              ? genreId.toInt()
              : int.tryParse(genreId.toString()),
        )
        .whereType<int>()
        .toSet();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(movie == null ? 'Add movie' : 'Update movie'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AdminPanelPage._field(titleController, 'Title'),
                AdminPanelPage._field(posterController, 'Poster URL'),
                AdminPanelPage._field(
                  overviewController,
                  'Overview',
                  maxLines: 3,
                ),
                AdminPanelPage._field(releaseDateController, 'Release date'),
                AdminPanelPage._field(
                  ratingController,
                  'Rating',
                  keyboardType: TextInputType.number,
                ),
                Wrap(
                  spacing: 8,
                  children: genreNames.entries.map((entry) {
                    final genreId = entry.key;
                    return FilterChip(
                      selectedColor: Colors.purple,
                      label: Text(entry.value),
                      selected: selectedGenreIds.contains(genreId),
                      onSelected: (selected) {
                        setDialogState(() {
                          if (selected) {
                            selectedGenreIds.add(genreId);
                          } else {
                            selectedGenreIds.remove(genreId);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isEmpty) return;

              Navigator.pop(dialogContext, {
                'title': title,
                'poster_path': posterController.text.trim(),
                'overview': overviewController.text.trim(),
                'release_date': releaseDateController.text.trim(),
                'vote_average': double.tryParse(ratingController.text) ?? 0,
                'genre_ids': selectedGenreIds.toList(),
              });
            },
            child: Text(movie == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );

    titleController.dispose();
    posterController.dispose();
    overviewController.dispose();
    releaseDateController.dispose();
    ratingController.dispose();
    return result;
  }

  Future<void> _addMovie(BuildContext context) async {
    final movie = await _showMovieDialog(context);
    if (movie == null || !context.mounted) return;
    await context.read<MoviesProvider>().addMovie(movie);
  }

  Future<void> _updateMovie(
    BuildContext context,
    Map<String, dynamic> movie,
  ) async {
    final updatedMovie = await _showMovieDialog(context, movie: movie);
    if (updatedMovie == null || !context.mounted) return;
    await context.read<MoviesProvider>().updateMovie(
      movie['id'].toString(),
      updatedMovie,
    );
  }

  Future<void> _removeMovie(
    BuildContext context,
    Map<String, dynamic> movie,
  ) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove movie?'),
        content: Text(
          'Remove ${movie['title'] ?? 'this movie'} from the catalog?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (shouldRemove != true || !context.mounted) return;
    await context.read<MoviesProvider>().removeMovie(movie['id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(218, 0, 0, 0),

      appBar: AppBar(
        title: const Text(
          'Admin Panel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            onPressed: () => _addMovie(context),
            icon: const Icon(Icons.add),
            tooltip: 'Add movie',
          ),
        ],
      ),
      body: Consumer<MoviesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }
          if (provider.movies.isEmpty) {
            return const Center(child: Text('No movies available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.movies.length,
            itemBuilder: (context, index) {
              final movie = provider.movies[index];
              return Card(
                color: Colors.grey[900],
                child: ListTile(
                  leading: movie['poster_path'] == null
                      ? const Icon(Icons.movie)
                      : getMoviePoster(movie['poster_path'].toString(), 50, 70),
                  title: Text(
                    movie['title']?.toString() ?? 'Untitled',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "${movie['release_date']?.toString() ?? ''} _  ${getGenres(movie['genre_ids']).join(' • ')}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        onPressed: () => _updateMovie(context, movie),
                        icon: const Icon(Icons.edit),
                        tooltip: 'Update movie',
                      ),
                      IconButton(
                        onPressed: () => _removeMovie(context, movie),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Remove movie',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
