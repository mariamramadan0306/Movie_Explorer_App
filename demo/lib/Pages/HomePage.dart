import 'package:demo/Pages/GenresPage.dart';
import 'package:demo/Pages/LoginPage.dart';
import 'package:demo/Pages/MoviesPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(218, 0, 0, 0),

      appBar: AppBar(
        title: Text(
          "Movie Explorer App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoviesPage()),
                );
              },
              icon: Icon(Icons.movie_filter_sharp),
              label: Text("View Movies", style: TextStyle(fontSize: 17)),
              style: ElevatedButton.styleFrom(fixedSize: const Size(250, 50)),
            ),

            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GenresPage()),
                );
              },
              icon: Icon(Icons.type_specimen),
              label: Text("View Genres", style: TextStyle(fontSize: 17)),
              style: ElevatedButton.styleFrom(fixedSize: const Size(250, 50)),
            ),
            SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  //clear navigation stack
                  (route) => false,
                );
              },
              icon: Icon(Icons.logout),
              label: Text("logout"),
            ),
          ],
        ),
      ),
    );
  }
}
