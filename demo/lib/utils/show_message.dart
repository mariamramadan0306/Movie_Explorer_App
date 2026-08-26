import 'package:flutter/material.dart';

void showMessage(String message, BuildContext context, bool mounted) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
