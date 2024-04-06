import 'package:flutter/material.dart';
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
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Home",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Set app bar color to match background
        elevation: 0, // Remove elevation
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 50), // Padding added to push content down
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Generator Name",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10), // Adding space between text rows and buttons
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "CAT C32 (50 HZ)",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Adding space between text rows and buttons
              Expanded(
                child: Center( // Centering the last row
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: [
                      _buildButton(context, 'Coolant Temperature', 'assets/coolant_temperature.png', const Temp()),
                      _buildButton(context, 'Fuel Level', 'assets/fuel_level.png', const Fuel()),
                      _buildButton(context, 'Oil Pressure', 'assets/oil_pressure.png', const OilPressure()),
                      _buildButton(context, 'Current/Load', 'assets/current_load.png', const Current()),
                      _buildButton(context, 'Vibration', 'assets/vibration.png', const Vibration()),
                      _buildButton(context, 'Sound', 'assets/sound.png', const Sound()),
                      _buildButton(context, 'Gas', 'assets/gas.png', const Gas()),
                      _buildButton(context, 'Operating Hours', 'assets/operating_hours.png', const OpHours()),
                      _buildButton(context, 'Next MD', 'assets/next_md.png', const NextMD()),
                      _buildButton(context, 'RUL', 'assets/rul.png', const Rul()),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[300], // Change color as needed
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
            const SizedBox(height: 8), // Adding space between image and text
            Text(
              buttonText,
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

