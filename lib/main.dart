import 'package:flutter/material.dart';
import 'package:sqflite_test/home.dart';

void main() {
  runApp(SqfLite());
}

class SqfLite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
