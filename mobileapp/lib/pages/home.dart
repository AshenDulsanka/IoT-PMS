import 'package:flutter/material.dart';
import '../main.dart'; // Import the login page

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
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  _buildButton(context, 'Coolant Temperature', 'assets/coolant_temperature.png'),
                  _buildButton(context, 'Fuel Level', 'assets/fuel_level.png'),
                  _buildButton(context, 'Oil Pressure', 'assets/oil_pressure.png'),
                  _buildButton(context, 'Current/Load', 'assets/current_load.png'),
                  _buildButton(context, 'Vibration', 'assets/vibration.png'),
                  _buildButton(context, 'Sound', 'assets/sound.png'),
                  _buildButton(context, 'Gas', 'assets/gas.png'),
                  _buildButton(context, 'Operating Hours', 'assets/operating_hours.png'),
                  _buildButton(context, 'Next MD', 'assets/next_md.png'),
                  _buildLastButton(context, 'RUL', 'assets/rul.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String buttonText, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Navigate to another page
        // Example:
        // Navigator.push(context, MaterialPageRoute(builder: (context) => AnotherPage()));
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

  Widget _buildLastButton(BuildContext context, String buttonText, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Navigate to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => login()), // Replace the current route
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
