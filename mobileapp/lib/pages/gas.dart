import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Gas extends StatefulWidget {
  const Gas({Key? key}) : super(key: key);

  @override
  _GasState createState() => _GasState();
}

class _GasState extends State<Gas> {
  final databaseRef = FirebaseDatabase.instance.ref().child('sensors');
  String _gas = '';

  @override
  void initState() {
    super.initState();
    databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _gas = data['smoke'].toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gasLevel = int.tryParse(_gas) ?? 0;
    final status = gasLevel > 3000 ? "Status: Critical" : "Status: Normal";

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          "Gas Level",
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
            padding: EdgeInsets.fromLTRB(20.0, 190.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage("assets/gas.png"),
                  width: 200,
                  height: 200,
                  alignment: Alignment.topCenter,
                ),
                SizedBox(height: 10),
                Text(
                  status,
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
      ),
    );
  }
}
