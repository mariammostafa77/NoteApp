import 'package:flutter/material.dart';

class DoneScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
          'Done Screen',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
    );
  }

}