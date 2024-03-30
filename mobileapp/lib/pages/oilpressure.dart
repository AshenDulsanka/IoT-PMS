import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OilPressure extends StatefulWidget {
  const OilPressure({Key? key}) : super(key: key);

  @override
  _OilPressureState createState() => _OilPressureState();
}

class _OilPressureState extends State<OilPressure> {
  final databaseRef = FirebaseDatabase.instance.ref().child('sensors');
  String _oilpressure = '';

  @override
  void initState() {
    super.initState();
    databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _oilpressure = data['oil_pressure'].toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final oilPressureLevel = int.tryParse(_oilpressure) ?? 0;
    String status;

    if (oilPressureLevel < 10) {
      status = "Status: Critically Low";
    } else if (oilPressureLevel < 25) {
      status = "Status: Very Low";
    } else if (oilPressureLevel < 65) {
      status = "Status: Normal";
    } else if (oilPressureLevel < 80) {
      status = "Status: Very High";
    } else {
      status = "Status: Critically High";
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          "Oil Pressure",
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
                  image: AssetImage("assets/oil_pressure.png"),
                  width: 200,
                  height: 200,
                  alignment: Alignment.topCenter,
                ),
                SizedBox(height: 20),
                Text(
                  _oilpressure + " psi",
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
