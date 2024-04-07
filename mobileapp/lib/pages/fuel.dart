import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:mobileapp/Analytics/fuel/10DaysLineChart.dart';
import 'package:mobileapp/Analytics/fuel/1DayLineChart.dart';
import 'package:mobileapp/Analytics/fuel/1HourLineChart.dart';
import 'package:mobileapp/Analytics/fuel/fuel1DayData.dart';
import 'package:mobileapp/Analytics/fuel/fuel10DaysData.dart';
import 'package:mobileapp/Analytics/fuel/fuel1HourData.dart';

class Fuel extends StatefulWidget {
  const Fuel({super.key});

  @override
  _FuelState createState() => _FuelState();
}

class _FuelState extends State<Fuel> {
  final databaseRef = FirebaseDatabase.instance.ref().child('sensors');
  String _fuel = '';
  String? _deviceToken;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _messaging.getToken().then((token) {
      print('Device token: $token');
      _deviceToken = token;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message: ${message.notification?.body}');
    });

    databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final fuelLevel = data['fuel_level'] as double? ?? 0.0;
        final fuelPercentage = ((fuelLevel / 25) * 100).toStringAsFixed(2);
        _sendNotificationWithoutWidgetCheck(fuelPercentage);
        setState(() {
          _fuel = fuelPercentage;
        });
      }
    });
  }

  Future<void> _sendNotificationWithoutWidgetCheck(String fuelPercentage) async {
    final fuelValue = double.tryParse(fuelPercentage) ?? 0.0;
    if (fuelValue < 25.0) {
      await _sendNotification("Fuel Level is Low");
    }
  }

  Future<void> _sendNotification(String body) async {
    const String serverKey =
        'AAAAMr10t2E:APA91bGIjp_V3WynamWaN0OitufgFjaGbPE5WDOcM9Vi_zGW91-oiGMkkv6vu5736vTXXfuJ1AflJr3N7PH-8qYXdJ3xbDmiBeFo83GKRE-EpYlh64Hmt7K1Vzy9hgY1Al3LdchObdR1';
    final String? deviceToken = _deviceToken;

    if (deviceToken == null) {
      print('Device token is not available');
      return;
    }

    final Map<String, dynamic> notificationData = {
      'notification': {
        'title': 'Fuel Status',
        'body': body,
      },
      'to': deviceToken,
    };

    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(notificationData),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final fuelPercentage = double.tryParse(_fuel) ?? 0.0;
    final status = fuelPercentage < 25.0 ? "Status: Fuel Level is Low" : "Status: Normal";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Fuel Level",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20.0, 150.0, 20.0, 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Image(
                    image: AssetImage("assets/fuel_level.png"),
                    width: 200,
                    height: 200,
                    alignment: Alignment.topCenter,
                  ),
                  Text(
                    "$_fuel %",
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 18,
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
      ),
    );
  }
}