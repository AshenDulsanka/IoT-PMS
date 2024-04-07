import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobileapp/Analytics/temp/temp1HourData.dart';
import 'package:mobileapp/Analytics/temp/temp10DaysData.dart';
import 'package:mobileapp/Analytics/temp/1HourLineChart.dart';
import 'package:mobileapp/Analytics/temp/1DayLineChart.dart';
import 'package:mobileapp/Analytics/temp/10DaysLineChart.dart';
import 'package:mobileapp/Analytics/temp/temp1DayData.dart';

import 'next_maintenance_date.dart';

class Temp extends StatefulWidget {
  const Temp({super.key});

  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  final databaseRef = FirebaseDatabase.instance.ref().child('sensors');
  String _temp = '';
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
        final tempValue = data['temperature'].toString();
        _sendNotificationWithoutWidgetCheck(tempValue);
        setState(() {
          _temp = tempValue;
        });
      }
      NextMaintenanceDateManager.updateNextMaintenanceDate({
        'temperatureValue': double.parse(_temp),
      });
    });
  }

  Future<void> _sendNotificationWithoutWidgetCheck(String tempValue) async {
    final temperature = double.tryParse(tempValue) ?? 0.0;
    String notificationMessage;

    if (temperature >= 100) {
      notificationMessage = "Temperature is Critical";
    } else if (temperature >= 80) {
      notificationMessage = "Temperature High";
    } else {
      return; // Temperature is in normal range, no notification needed
    }

    await _sendNotification(notificationMessage);
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
        'title': 'Warning!',
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
    final tempValue = double.tryParse(_temp) ?? 0.0;
    String status;

    if (tempValue < 45) {
      status = "Status: Temperature is low";
    } else if (tempValue < 80) {
      status = "Status: Normal";
    } else if (tempValue < 100) {
      status = "Status: Temperature High";
    } else {
      status = "Status: Critical";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Coolant Temperature",
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
                    image: AssetImage("assets/coolant_temperature.png"),
                    width: 200,
                    height: 200,
                    alignment: Alignment.topCenter,
                  ),
                  const SizedBox(height: 60),
                  Text(
                    "${tempValue.toStringAsFixed(1)}°C",
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
                  FutureBuilder<List<HourTempData>>(
                    future: get1HourTempData(),
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
                  FutureBuilder<List<DayTempData>>(
                    future: get1DayTempData(),
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
                  FutureBuilder<List<Days10TempData>>(
                    future: get10DaysTempData(),
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