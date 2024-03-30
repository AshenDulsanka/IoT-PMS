import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Fuel extends StatefulWidget {
  const Fuel({Key? key}) : super(key: key);

  @override
  _FuelState createState() => _FuelState();
}

class _FuelState extends State<Fuel> {
  final databaseRef = FirebaseDatabase.instance.ref().child('sensors');
  String _fuel = '';

  @override
  void initState() {
    super.initState();
    databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          final fuelLevel = data['fuel_level'] as int? ?? 0;
          _fuel = ((fuelLevel / 25) * 100).toStringAsFixed(2);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fuelPercentage = double.tryParse(_fuel) ?? 0.0;
    final status = fuelPercentage < 25.0 ? "Status: Critical" : "Status: Normal";

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          "Fuel Level",
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
            padding: EdgeInsets.fromLTRB(20.0, 150.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage("assets/fuel_level.png"),
                  width: 200,
                  height: 200,
                  alignment: Alignment.topCenter,
                ),
                Text(
                  _fuel + " %",
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
