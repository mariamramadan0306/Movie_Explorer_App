import 'package:demo/utils/get_Initials.dart';
import 'package:demo/utils/load_admin_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Moviesdrawer extends StatefulWidget {
  const Moviesdrawer({super.key});

  @override
  State<Moviesdrawer> createState() => _MoviesdrawerState();
}

class _MoviesdrawerState extends State<Moviesdrawer> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final Future<bool> _adminStatus = loadAdminStatus(auth);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              auth.currentUser!.displayName!,
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              auth.currentUser!.email!,
              style: TextStyle(color: const Color.fromARGB(255, 192, 192, 192)),
            ),
            currentAccountPicture: CircleAvatar(
              child: Text(
                getInitials(auth.currentUser!.displayName!),
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
              Navigator.pushNamed(context, '/home');
            },
          ),
          FutureBuilder<bool>(
            future: _adminStatus,
            builder: (context, snapshot) {
              if (snapshot.data != true) return const SizedBox.shrink();

              return ListTile(
                leading: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                ),
                title: const Text(
                  "Admin panel",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/admin');
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text("Settings Page", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          SizedBox(height: 20),
          Card(
            color: const Color.fromARGB(255, 44, 44, 44),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text("Logout", style: TextStyle(color: Colors.white)),
              onTap: () async {
                await auth.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
