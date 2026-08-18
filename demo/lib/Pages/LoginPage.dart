import 'package:demo/Pages/HomePage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(132, 37, 36, 36),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_creation_outlined,
              size: 200,
              color: Colors.purple,
            ),
            Text(
              "Welcome to Movie Explorer App",
              style: TextStyle(fontSize: 16, color: Colors.purple[50]),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                //Widget that triggered the navigation
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              icon: Icon(Icons.movie),
              label: Text("Enter App"),
            ),
          ],
        ),
      ),
    );
  }
}
