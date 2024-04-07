import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class OpHours extends StatefulWidget {
  const OpHours({super.key});

  @override
  _OpHoursState createState() => _OpHoursState();
}

class _OpHoursState extends State<OpHours> {
  final databaseRef = FirebaseDatabase.instance.ref().child('sensors');
  String _vibration = '';
  double _operatingHours = 0;
  late StreamSubscription _databaseSubscription;

  @override
  void initState() {
    super.initState();
    _databaseSubscription = databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final vibration = data['vibration'].toString();
        double vibrationValue = double.tryParse(_vibration) ?? 0.0;
        if (vibrationValue > 20) {
          _incrementOperatingHours();
        }
        setState(() {
          _vibration = vibration;
        });
      }
    });
  }

  void _incrementOperatingHours() {
    setState(() {
      _operatingHours += 0.01;
    });
  }

  @override
  void dispose() {
    _databaseSubscription.cancel(); // Cancel the database listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Operating Hours",
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
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ), // Remove elevation
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20.0, 150.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Image(
                  image: AssetImage("assets/operating_hours.png"),
                  width: 200,
                  height: 200,
                  alignment: Alignment.topCenter,
                ),
                const SizedBox(height: 80),
                Text(
                  "${_operatingHours.toStringAsFixed(2)} hrs",
                  style: const TextStyle(
                    fontSize: 50,
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