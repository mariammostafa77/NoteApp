import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Tasks Screen',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}