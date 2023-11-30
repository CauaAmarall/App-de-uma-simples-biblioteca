import 'package:flutter/material.dart';
import 'package:desafio_flutter/screens/bookshelf_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ebook Reader App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookshelfScreen(),
    );
  }
}
