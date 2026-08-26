import 'package:demo/utils/show_message.dart';
import 'package:demo/utils/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showChangePasswordModal(BuildContext context, bool mounted) {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final ConfirmNewPasswordController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Confirm password field is required";
    }
    if (value != newPasswordController.text) {
      return "Password do not match";
    }
    return null;
  }

  Future<void> changePassword() async {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmNewPassword = ConfirmNewPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      showMessage("Please enter you password", context, mounted);
      return;
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      final validPassword = validatePassword(newPassword);
      if (validPassword != null) {
        showMessage(validPassword, context, mounted);
        return;
      }
      final correctNewPassword = validateConfirmPassword(confirmNewPassword);
      if (correctNewPassword != null) {
        showMessage(correctNewPassword, context, mounted);
        return;
      }
      await user.updatePassword(newPassword);
      Navigator.pop(context);

      showMessage("Password changed successfully", context, mounted);
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          message = "Old password is incorrect";
          break;

        case 'weak-password':
          message = "New password is too weak";
          break;

        case 'requires-recent-login':
          message = "Please login again before changing your password";
          break;

        default:
          message = e.message ?? "Failed to change password";
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
          "Change Password",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your old paasword and the new one.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 15),
            TextField(
              controller: oldPasswordController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.password, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: newPasswordController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "New password",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.key_off, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ConfirmNewPasswordController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Confirm new password",
                hintStyle: const TextStyle(color: Colors.grey),
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
            onPressed: changePassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text("Change"),
          ),
        ],
      );
    },
  );
}
