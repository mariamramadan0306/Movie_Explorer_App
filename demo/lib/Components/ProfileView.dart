import 'package:demo/utils/get_Initials.dart';
import 'package:flutter/material.dart';
import 'package:demo/Providers/UserDataProvider.dart';
import 'package:provider/provider.dart';

class Profileview extends StatelessWidget {
  const Profileview({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<UserDataModel>(
        builder: (context, user, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: CircleAvatar(
                radius: 70,
                child: Text(
                  getInitials(user),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text(
              user.userData["name"] ?? "User",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            Text(
              user.userData["email"] ?? "",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Divider(height: 50, color: Colors.grey[800]),
            Card(
              color: const Color.fromARGB(255, 44, 44, 44),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: Icon(
                  Icons.change_circle_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  "Change Password",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
            ),
            Card(
              color: const Color.fromARGB(255, 44, 44, 44),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text(
                  "Settings Page",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
