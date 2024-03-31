import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class Current extends StatefulWidget {
  const Current({Key? key}) : super(key: key);

  @override
  _CurrentState createState() => _CurrentState();
}

class _CurrentState extends State<Current> {
  final databaseRef = FirebaseDatabase.instance.ref().child('sensors');
  String _current = '';

  @override
  void initState() {
    super.initState();
    databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          final currentLevel = data['current'] as int? ?? 0;
          _current = ((currentLevel / 10) * 100).toStringAsFixed(2);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPercentage = double.tryParse(_current) ?? 0.0;
    String status;

    if (currentPercentage < 30.0) {
      status = "Status: Warning! Very Low Current";
    } else if (currentPercentage < 70.0) {
      status = "Status: Load is Low";
    } else {
      status = "Status: Normal";
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          "Current/ Load",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[900], // Set app bar color to match background
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),// Remove elevation
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(20.0, 120.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage("assets/current_load.png"),
                  width: 200,
                  height: 200,
                  alignment: Alignment.topCenter,
                ),
                SizedBox(height: 40),
                Text(
                  _current + "%", // Display the current value from Firebase
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
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