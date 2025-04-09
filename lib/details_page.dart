import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String? branchName;  // Accept branchName as a parameter

  const DetailsPage({super.key, this.branchName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(branchName ?? "No Branch Name"),
        backgroundColor: Colors.teal.shade200,
      ),
      body: Center(
        child: Text(
          "Welcome to $branchName",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}