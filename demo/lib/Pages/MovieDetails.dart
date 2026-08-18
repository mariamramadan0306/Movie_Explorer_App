import 'package:flutter/material.dart';

class MovieDetails extends StatelessWidget {
  late String name;
  late String url;
  late String year;
  late String description;
  late String rating;
  late String genres;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(132, 37, 36, 36),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(132, 37, 36, 36),
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
              child: Image.network(
                url,
                width: 450,
                height: 320,
                fit: BoxFit.cover,
              ),
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
                    name,
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        year,
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                      Text(
                        "  •  ",
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                      Icon(Icons.star_rate, color: Colors.yellow, size: 15),
                      SizedBox(width: 5),
                      Text(
                        rating,
                        style: TextStyle(color: Colors.yellow, fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    genres,
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
                        description,
                        style: TextStyle(color: Colors.grey[400], fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
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
