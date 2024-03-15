import 'package:flutter/material.dart';
import './home.dart';

class OpHours extends StatelessWidget {
  const OpHours({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(20.0, 200.0, 20.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(
                image: AssetImage("assets/operating_hours.png"),
                width: 200,
                height: 200,
                alignment: Alignment.topCenter,
              ),
              SizedBox(height: 40),
              Text(
                "Operating Hours",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 60),
              Text(
                "25 hrs",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontFamily: "Poppins",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}