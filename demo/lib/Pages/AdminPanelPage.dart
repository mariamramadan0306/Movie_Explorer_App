import 'package:flutter/material.dart';

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.purple,
      ),
      body: const Center(child: Text('Admin panel')),
    );
  }
}
