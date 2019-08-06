import 'package:flutter/material.dart';
import 'SaperGame.dart';

void main() {
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saper',
      
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: SaperGame(),
    );
  }
}