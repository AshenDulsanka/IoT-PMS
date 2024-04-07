import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NextMaintenanceDateManager {
  static int _nextMaintenanceDays = 300;
  static String? _deviceToken;

  static void updateNextMaintenanceDate(Map<String, dynamic> values) {
    // Check if any condition is not normal
    bool isAbnormal = false;
    double? currentValue = values['currentValue'] as double?;
    double? temperatureValue = values['temperatureValue'] as double?;
    int? oilPressureValue = values['oilPressureValue'] as int?;
    int? vibrationValue = values['vibrationValue'] as int?;
    double? fuelValue = values['fuelValue'] as double?;
    int? gasValue = values['gasValue'] as int?;
    int? soundValue = values['soundValue'] as int?;

    if (currentValue != null && (currentValue < 30.0)) {
      isAbnormal = true;
    }
    if (temperatureValue != null && (temperatureValue < 45.0 || temperatureValue > 100.0)) {
      isAbnormal = true;
    }
    if (oilPressureValue != null && (oilPressureValue < 10 || oilPressureValue > 80)) {
      isAbnormal = true;
    }
    if (vibrationValue != null && vibrationValue > 25) {
      isAbnormal = true;
    }
    if (fuelValue != null && fuelValue < 25.0) {
      isAbnormal = true;
    }
    if (gasValue != null && gasValue > 3000) {
      isAbnormal = true;
    }
    if (soundValue != null && soundValue > 95) {
      isAbnormal = true;
    }

    if (isAbnormal) {
      _nextMaintenanceDays -= 40;
      if (_nextMaintenanceDays < 0) {
        _nextMaintenanceDays = 0;
      }
      // Send a notification to the user
      _sendNotification("Warning! Next maintenance date has been reduced due to abnormal conditions.");
    } else {
      _nextMaintenanceDays -= 1;
    }
  }

  static int get nextMaintenanceDays => _nextMaintenanceDays;

  static Future<void> _sendNotification(String body) async {
    const String serverKey = 'AAAAMr10t2E:APA91bGIjp_V3WynamWaN0OitufgFjaGbPE5WDOcM9Vi_zGW91-oiGMkkv6vu5736vTXXfuJ1AflJr3N7PH-8qYXdJ3xbDmiBeFo83GKRE-EpYlh64Hmt7K1Vzy9hgY1Al3LdchObdR1';
    final String? deviceToken = _deviceToken;

    if (deviceToken == null) {
      print('Device token is not available');
      return;
    }

    final Map<String, dynamic> notificationData = {
      'notification': {
        'title': 'Next Maintenance Date Update',
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

  static void setDeviceToken(String? token) {
    _deviceToken = token;
  }
}