import 'package:demo/Providers/UserDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profileview extends StatelessWidget {
  const Profileview({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<UserDataModel>(
        builder: (context, user, child) => Column(
          children: [
            Icon(
              Icons.person,
              color: const Color.fromARGB(255, 180, 91, 196),
              size: 250,
            ),
            Text(
              user.userData["name"],
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            Text(
              user.userData["email"],
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
