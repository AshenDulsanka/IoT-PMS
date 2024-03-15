import 'package:flutter/material.dart';
import './home.dart';

class Gas extends StatelessWidget {
  const Gas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(20.0, 220.0, 20.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(
                image: AssetImage("assets/gas.png"),
                width: 200,
                height: 200,
                alignment: Alignment.topCenter,
              ),
              Text(
                "Gas Level",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 80),
              Text(
                "Status: Normal",
                style: TextStyle(
                  fontSize: 40,
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