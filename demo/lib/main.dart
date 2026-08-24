import 'package:demo/Pages/GenresPage.dart';
import 'package:demo/Pages/HomePage.dart';
import 'package:demo/Pages/LoginPage.dart';
import 'package:demo/Pages/MoviesPage.dart';
import 'package:demo/Providers/FavouriteMoviesProvider.dart';
import 'package:demo/Providers/UserDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FavouriteMoviesModel>(
          create: (context) => FavouriteMoviesModel(),
        ),
        ChangeNotifierProvider<UserDataModel>(
          create: (context) => UserDataModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
