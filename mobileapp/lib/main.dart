import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Scaffold(
    appBar: AppBar(
      title: Text("UpTime"),
      centerTitle: true,
      backgroundColor: Colors.grey[800],
    ),
    body: Center(
      child: Text(
        "Hello user",
        style: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 10,
          color: Colors.grey[700],

        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      child: Text("click"),
      backgroundColor: Colors.white10,
    ),
  ),
));

