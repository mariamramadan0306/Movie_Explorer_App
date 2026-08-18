import 'package:demo/Pages/GenresPage.dart';
import 'package:demo/Pages/HomePage.dart';
import 'package:demo/Pages/LoginPage.dart';
import 'package:demo/Pages/MoviesPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Explorer App',
      initialRoute: '/login',
      routes: {
        "/login": (context) => LoginPage(),
        "/home": (context) => HomePage(),
        "/movies": (context) => MoviesPage(),
        "/genres": (context) => GenresPage(),
      },
      // home: LoginPage(),
    );
  }
}
