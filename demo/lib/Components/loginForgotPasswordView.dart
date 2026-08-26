import 'package:demo/utils/show_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showForgotPasswordModal(BuildContext context, bool mounted) {
  final emailController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage("Please enter you email", context, mounted);
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@[\w-\.]+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      showMessage("enter a valid email", context, mounted);
      return;
    }

    try {
      await auth.sendPasswordResetEmail(email: email);
      showMessage(
        "Password reset email sent, Please check you email",
        context,
        mounted,
      );
      await Future.delayed(Duration(seconds: 1));
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = "email address is not valid";
          break;
        case 'user-not-found':
          message = "Account doesn't exist with this email";
          break;
        case 'too-many-requests':
          message = "Too many login attempts, try again after 1 min";
          break;
        case 'operation-not-allowed':
          message = "Email/Password Authentication is not enabled";
          break;
        default:
          message = e.message ?? "something went wrong";
      }
      showMessage(message, context, mounted);
    } catch (e) {
      showMessage("something went wrong", context, mounted);
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your email address and we'll send you a link to reset your password.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Email address",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),

          ElevatedButton(
            onPressed: resetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text("Send Link"),
          ),
        ],
      );
    },
  );
}
