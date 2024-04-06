import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OilPressure extends StatefulWidget {
  const OilPressure({super.key});

  @override
  _OilPressureState createState() => _OilPressureState();
}

class _OilPressureState extends State<OilPressure> {
  final databaseRef = FirebaseDatabase.instance.ref().child('sensors');
  String _oilpressure = '';
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
        final oilPressure = data['oil_pressure'].toString();
        _sendNotificationWithoutWidgetCheck(oilPressure);
        setState(() {
          _oilpressure = oilPressure;
        });
      }
    });
  }

  Future<void> _sendNotificationWithoutWidgetCheck(String oilPressure) async {
    final oilPressureLevel = int.tryParse(oilPressure) ?? 0;
    String notificationMessage;

    if (oilPressureLevel < 10) {
      notificationMessage = "Oil Pressure is Critically Low";
    } else if (oilPressureLevel < 25) {
      notificationMessage = "Oil Pressure is Very Low";
    } else if (oilPressureLevel > 80) {
      notificationMessage = "Oil Pressure is Critically High";
    } else if (oilPressureLevel > 65) {
      notificationMessage = "Oil Pressure is Very High";
    } else {
      return; // Oil pressure is in normal range, no notification needed
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
        'title': 'Oil Pressure Status',
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Oil Pressure",
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
        child: Center(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20.0, 150.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Image(
                  image: AssetImage("assets/oil_pressure.png"),
                  width: 200,
                  height: 200,
                  alignment: Alignment.topCenter,
                ),
                const SizedBox(height: 20),
                Text(
                  "$_oilpressure psi",
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
    );
  }
}