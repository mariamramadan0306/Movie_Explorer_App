import 'package:demo/Components/changePasswordView.dart';
import 'package:demo/utils/get_Initials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profileview extends StatefulWidget {
  const Profileview({super.key});

  @override
  State<Profileview> createState() => _ProfileviewState();
}

class _ProfileviewState extends State<Profileview> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: CircleAvatar(
              radius: 70,
              child: Text(
                getInitials(auth.currentUser!.displayName!),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Text(
            auth.currentUser!.displayName!,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          Text(
            auth.currentUser!.email!,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Divider(height: 50, color: Colors.grey[800]),
          Card(
            color: const Color.fromARGB(255, 44, 44, 44),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(Icons.change_circle_outlined, color: Colors.white),
              title: Text(
                "Change Password",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                showChangePasswordModal(context, mounted);
              },
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
    );
  }
}
