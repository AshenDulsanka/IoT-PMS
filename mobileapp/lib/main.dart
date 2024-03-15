import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("My First App"),
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[600],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text("Hello, World!"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text("Click"),
        backgroundColor: Colors.grey[600],
      ),
    );
  }
}
