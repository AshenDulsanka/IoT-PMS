import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() => runApp(const MaterialApp(
  home: login(),
));

class login extends StatelessWidget {
  const login({super.key});

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
              const Image(
                image: AssetImage("assets/UpTime-login.png"),
                width: 200,
                height: 200,
                alignment: Alignment.topCenter,
              ),
              const SizedBox(height: 20), // Adding space between the Image and the Text
              const Text(
                "UpTime Login",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(height: 80), // Adding space between the Text and the TextFields
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  fillColor: Colors.grey[600],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Add border radius
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Adjust content padding
                  hintStyle: const TextStyle(color: Colors.white), // Change color of hint text
                ),
                style: const TextStyle(color: Colors.white), // Change color of input text
              ),
              const SizedBox(height: 40), // Adding space between the TextFields
              TextField(
                decoration: InputDecoration(
                  hintText: 'Password',
                  fillColor: Colors.grey[600],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Add border radius
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Adjust content padding
                  hintStyle: const TextStyle(color: Colors.white), // Change color of hint text
                ),
                style: const TextStyle(color: Colors.white), // Change color of input text
                obscureText: true, // Hides the password
              ),
              const SizedBox(height: 10), // Adding space between the Password field and Forgot Password
              const SizedBox(height: 50), // Adding space at the bottom
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                  minimumSize: MaterialStateProperty.all<Size>(Size(150, 50)), // Adjust button size
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
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
