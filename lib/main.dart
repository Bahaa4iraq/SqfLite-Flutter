import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_test/home.dart';

void main() {
  runApp(SqfLite());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent),
  );
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
