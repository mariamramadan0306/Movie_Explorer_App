import 'package:demo/Components/MoviesFavouriteView.dart';
import 'package:demo/Components/MoviesHomeView.dart';
import 'package:demo/Components/MoviesSearchView.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: const Color.fromARGB(132, 37, 36, 36),

      appBar: AppBar(
        title: Text(
          "Movies Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: getBody(),
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

  Widget getBody() {
    switch (selectedIndex) {
      case 0:
        return homeView(favoriteMovies);

      case 1:
        return SearchPage(favoriteMovies: favoriteMovies);

      case 2:
        return favoriteView(favoriteMovies);

      case 3:
        return profileView();

      default:
        return homeView(favoriteMovies);
    }
  }

  Widget profileView() {
    return Center(
      child: Text(
        "Profile",
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
    );
  }
}
