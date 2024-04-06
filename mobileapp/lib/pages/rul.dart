import 'package:flutter/material.dart';
import './home.dart';

class Rul extends StatelessWidget {
  const Rul({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Remaining Useful Life",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Set app bar color to match background
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),// Remove elevation
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(20.0, 150.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage("assets/rul.png"),
                  width: 200,
                  height: 200,
                  alignment: Alignment.topCenter,
                ),
                SizedBox(height: 60),
                Text(
                  "25%",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Status: Normal",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
