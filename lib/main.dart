// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sqlite_crud/pages/home_pg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomePg(),
    );
  }
}
