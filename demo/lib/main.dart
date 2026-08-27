import 'package:demo/Pages/GenresPage.dart';
import 'package:demo/Pages/HomePage.dart';
import 'package:demo/Pages/LoginPage.dart';
import 'package:demo/Pages/MoviesPage.dart';
import 'package:demo/Providers/FavouriteMoviesProvider.dart';
import 'package:demo/Providers/MoviesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AuthenticatedApp());
}

class AuthenticatedApp extends StatelessWidget {
  const AuthenticatedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final user = snapshot.data;

        if (user == null || !user.emailVerified) {
          return const MyApp(home: LoginPage());
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider<MoviesProvider>(
              create: (_) => MoviesProvider()..startListening(),
            ),

            ChangeNotifierProvider<FavouritesProvider>(
              create: (_) => FavouritesProvider(user.uid)..startListening(),
            ),
          ],
          child: const MyApp(home: HomePage()),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Explorer App',
      home: home,
      routes: {
        "/login": (context) => LoginPage(),
        "/home": (context) => HomePage(),
        "/movies": (context) => MoviesPage(),
        "/genres": (context) => GenresPage(),
      },
    );
  }
}
