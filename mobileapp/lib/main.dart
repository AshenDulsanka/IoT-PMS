import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Container(
          height: 800, // Adjusted height for the container
          padding: EdgeInsets.all(20.0), // Added padding for better spacing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align children to the top
            children: [
              Image(
                image: AssetImage("assets/UpTime-login.png"),
                width: 200,
                height: 200,
                alignment: Alignment.topCenter,
              ),
              SizedBox(height: 20), // Adding space between the Image and the Text
              Text(
                "UpTime Login",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 80), // Adding space between the Text and the TextFields
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  fillColor: Colors.grey[600],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Add border radius
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Adjust content padding
                  hintStyle: TextStyle(color: Colors.white), // Change color of hint text
                ),
                style: TextStyle(color: Colors.white), // Change color of input text
              ),
              SizedBox(height: 40), // Adding space between the TextFields
              TextField(
                decoration: InputDecoration(
                  hintText: 'Password',
                  fillColor: Colors.grey[600],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Add border radius
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Adjust content padding
                  hintStyle: TextStyle(color: Colors.white), // Change color of hint text
                ),
                style: TextStyle(color: Colors.white), // Change color of input text
                obscureText: true, // Hides the password
              ),
              SizedBox(height: 10), // Adding space between the Password field and Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // Align children to the start
                children: [
                  TextButton(
                    onPressed: () {
                      // Add functionality for forgot password here
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.green,
                        decoration: TextDecoration.underline,

                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Adding space at the bottom
              ElevatedButton(
                onPressed: () {
                  // Add your login functionality here
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                  minimumSize: MaterialStateProperty.all<Size>(Size(150, 50)), // Adjust button size
                ),
              ),
              SizedBox(height: 30), // Adding space between Login button and Register Here
              TextButton(
                onPressed: () {
                  // Add functionality to navigate to registration page
                },
                child: Text(
                  "Don't have an account? Register here",
                  style: TextStyle(
                    color: Colors.green,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
