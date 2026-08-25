import 'package:demo/Pages/HomePage.dart';
import 'package:demo/Pages/SingInPage.dart';
import 'package:demo/utils/get_Initials.dart';
import 'package:flutter/material.dart';
import 'package:demo/Providers/UserDataProvider.dart';
import 'package:provider/provider.dart';

class Moviesdrawer extends StatefulWidget {
  const Moviesdrawer({super.key});

  @override
  State<Moviesdrawer> createState() => _MoviesdrawerState();
}

class _MoviesdrawerState extends State<Moviesdrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataModel>(
      builder: (context, user, child) => Drawer(
        backgroundColor: const Color.fromARGB(255, 53, 53, 53),
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            //   child: Card(
            //     color: const Color.fromARGB(255, 44, 44, 44),
            //     child: ListTile(
            //       leading: CircleAvatar(
            //         radius: 25,
            //         child: Text(
            //           getInitials(user),
            //           style: const TextStyle(
            //             fontSize: 18,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //       title: Text(
            //         user.userData["name"],
            //         style: TextStyle(color: Colors.white),
            //       ),
            //       subtitle: Text(
            //         user.userData["email"],
            //         style: TextStyle(
            //           color: const Color.fromARGB(255, 192, 192, 192),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              accountName: Text(
                user.userData["name"] ?? "User",
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                user.userData["email"] ?? "",
                style: TextStyle(
                  color: const Color.fromARGB(255, 192, 192, 192),
                ),
              ),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  getInitials(user),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text("Home Page", style: TextStyle(color: Colors.white)),
              onTap: () {
                //Widget that triggered the navigation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text(
                "Settings Page",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
            SizedBox(height: 20),
            Card(
              color: const Color.fromARGB(255, 44, 44, 44),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text("Logout", style: TextStyle(color: Colors.white)),
                onTap: () {
                  //Widget that triggered the navigation
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
