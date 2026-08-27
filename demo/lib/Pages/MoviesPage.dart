import 'package:demo/Components/MoviesDrawer.dart';
import 'package:demo/Components/MoviesFavouriteView.dart';
import 'package:demo/Components/MoviesHomeView.dart';
import 'package:demo/Components/MoviesSearchView.dart';
import 'package:demo/Components/ProfileView.dart';
import 'package:demo/Pages/ChatbotPage.dart';
import 'package:demo/utils/fetch_Movies.dart';
import 'package:demo/Providers/MoviesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  int selectedIndex = 0;
  Set<String> favoriteMovies = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(218, 0, 0, 0),
      appBar: AppBar(
        title: Text(
          "Movies Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder(
        future: fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error");
            }
            return getBody(snapshot);
          }
          return Text("");
        },
      ),
      bottomNavigationBar: Card(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navItem(Icons.home_filled, 0, Colors.white),
              _navItem(Icons.search, 1, Colors.white),
              _navItem(Icons.favorite_outlined, 2, Colors.red[900]!),
              _navItem(Icons.person_2_rounded, 3, Colors.white),
            ],
          ),
        ),
      ),
      endDrawer: Moviesdrawer(),
    );
  }

  Widget _navItem(IconData icon, int index, Color color) {
    bool isSelected = selectedIndex == index;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[800] : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {
          setState(() {
            selectedIndex = index;
          });
        },
        icon: Icon(icon, color: color),
      ),
    );
  }

  Widget getBody(AsyncSnapshot<List<dynamic>> snapshot) {
    switch (selectedIndex) {
      case 0:
        return Consumer<MoviesProvider>(
          builder: (context, moviesProvider, child) {
            return homeView(snapshot, newMovies: moviesProvider.movies);
          },
        );

      case 1:
        return SearchPage(
          snapshot,
          onOpenChat: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatbotPage(movies: snapshot.data ?? []),
              ),
            );
          },
        );

      case 2:
        return FavouriteView(snapshot);

      case 3:
        return Profileview();

      default:
        return homeView(snapshot);
    }
  }
}
