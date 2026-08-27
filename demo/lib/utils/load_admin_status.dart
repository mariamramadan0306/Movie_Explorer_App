import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> loadAdminStatus(FirebaseAuth auth) async {
  final user = auth.currentUser;
  if (user == null) return false;

  final document = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();
  return document.data()?['isAdmin'] == true;
}
