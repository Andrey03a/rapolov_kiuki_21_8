import 'package:flutter/material.dart';
import 'widgets/students_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Студенти',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey.shade200,
      ),
      home: const StudentsView(),
    );
  }
}
