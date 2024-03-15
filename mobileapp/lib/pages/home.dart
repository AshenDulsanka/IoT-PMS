import 'package:flutter/material.dart';
import '../main.dart'; // Import the login page
import './current.dart';
import './fuel.dart';
import './gas.dart';
import './oilpressure.dart';
import './ophours.dart';
import './rul.dart';
import './sound.dart';
import './temp.dart';
import './vibration.dart';
import './nextmd.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        padding: EdgeInsets.only(top: 120), // Padding added to push content down
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Generator Name",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10), // Adding space between text rows and buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Row 2",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 20), // Adding space between text rows and buttons
            Expanded(
              child: Center( // Centering the last row
                child: GridView.count(
                  crossAxisCount: 3,
                  children: [
                    _buildButton(context, 'Coolant Temperature', 'assets/coolant_temperature.png', Temp()),
                    _buildButton(context, 'Fuel Level', 'assets/fuel_level.png', Fuel()),
                    _buildButton(context, 'Oil Pressure', 'assets/oil_pressure.png', OilPressure()),
                    _buildButton(context, 'Current/Load', 'assets/current_load.png', Current()),
                    _buildButton(context, 'Vibration', 'assets/vibration.png', Vibration()),
                    _buildButton(context, 'Sound', 'assets/sound.png', Sound()),
                    _buildButton(context, 'Gas', 'assets/gas.png', Gas()),
                    _buildButton(context, 'Operating Hours', 'assets/operating_hours.png', OpHours()),
                    _buildButton(context, 'Next MD', 'assets/next_md.png', NextMD()),
                    _buildButton(context, 'RUL', 'assets/rul.png', Rul()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String buttonText, String imagePath, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[700], // Change color as needed
          borderRadius: BorderRadius.circular(8), // Add border radius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 50, // Adjust size as needed
              width: 50, // Adjust size as needed
            ),
            SizedBox(height: 8), // Adding space between image and text
            Text(
              buttonText,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
