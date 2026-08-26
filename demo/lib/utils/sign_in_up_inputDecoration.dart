import 'package:flutter/material.dart';

InputDecoration inputDecoration({
  required String label,
  required String hint,
  required IconData icon,
  IconButton? suffixIcon,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: Colors.white),
    hintText: hint,
    hintStyle: TextStyle(color: const Color.fromARGB(115, 255, 255, 255)),
    prefixIcon: Icon(icon, color: Colors.white),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 2),
    ),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: const Color.fromARGB(255, 59, 59, 59),
    suffixIcon: suffixIcon,
  );
}
