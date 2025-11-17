import 'package:flutter/material.dart';
import 'package:module14assignment/CRUD/c2_crud_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Module 14 Assignment',
      home: C2ApiCall()
    );
  }
}
