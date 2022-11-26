import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:note_app/shared/components/bloc_observer.dart';

import 'layouts/home_Screen.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        accentColor: Colors.teal,
      ),
      title: 'Flutter Demo',
      home: HomeScreen(),
    );
  }
}
