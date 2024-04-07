import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobileapp/Analytics/vibration/vib1DayData.dart';
import 'package:mobileapp/Analytics/vibration/vib1HourData.dart';
import 'package:mobileapp/Analytics/vibration/vib10DaysData.dart';
import 'package:mobileapp/Analytics/vibration/10DaysLineChart.dart';
import 'package:mobileapp/Analytics/vibration/1DayLineChart.dart';
import 'package:mobileapp/Analytics/vibration/1HourLineChart.dart';

import 'next_maintenance_date.dart';

class Vibration extends StatefulWidget {
  const Vibration({super.key});

  @override
  _VibrationState createState() => _VibrationState();
}

class _VibrationState extends State<Vibration> {
  final databaseRef = FirebaseDatabase.instance.ref().child('sensors');
  String _vibration = '';
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
        final vibration = data['vibration'].toString();
        _sendNotificationWithoutWidgetCheck(vibration);
        setState(() {
          _vibration = vibration;
        });
      }
      NextMaintenanceDateManager.updateNextMaintenanceDate({
        'vibrationValue': double.parse(_vibration),
      });
    });
  }

  Future<void> _sendNotificationWithoutWidgetCheck(String vibration) async {
    final vibrationValue = int.tryParse(vibration) ?? 0;
    if (vibrationValue > 25) {
      await _sendNotification();
    }
  }

  Future<void> _sendNotification() async {
    const String serverKey =
        'AAAAMr10t2E:APA91bGIjp_V3WynamWaN0OitufgFjaGbPE5WDOcM9Vi_zGW91-oiGMkkv6vu5736vTXXfuJ1AflJr3N7PH-8qYXdJ3xbDmiBeFo83GKRE-EpYlh64Hmt7K1Vzy9hgY1Al3LdchObdR1';
    final String? deviceToken = _deviceToken;

    if (deviceToken == null) {
      print('Device token is not available');
      return;
    }

    final Map<String, dynamic> notificationData = {
      'notification': {
        'title': 'Warning!',
        'body': 'Vibration is high, check the engine.',
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
    final vibrationValue = int.tryParse(_vibration) ?? 0;
    final status =
    vibrationValue > 25 ? "Status: Vibration is High" : "Status: Normal";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Vibration Level",
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
                    image: AssetImage("assets/vibration.png"),
                    width: 200,
                    height: 200,
                    alignment: Alignment.topCenter,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "$_vibration mm/s",
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
                  const SizedBox(height: 100),
                  const Text(
                    "1 Hour Data",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Poppins",
                    ),
                  ),
                  FutureBuilder<List<HourVibData>>(
                    future: get1HourVibData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                          height: 200,
                          child: LineChartWidget(snapshot.data!),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "1 Day Data",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Poppins",
                    ),
                  ),
                  FutureBuilder<List<DayVibData>>(
                    future: get1DayVibData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                          height: 200,
                          child: LineChartWidget1Day(snapshot.data!),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "10 Days Data",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Poppins",
                    ),
                  ),
                  FutureBuilder<List<Days10VibData>>(
                    future: get10DaysVibData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                          height: 200,
                          child: LineChartWidget10Days(snapshot.data!),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
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