class NextMaintenanceDateManager {
  static int _nextMaintenanceDays = 300;

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
      sendNotification("Warning! Next maintenance date has been reduced due to abnormal conditions.");
    } else {
      _nextMaintenanceDays -= 1;
    }
  }

  static int get nextMaintenanceDays => _nextMaintenanceDays;

  static void sendNotification(String message) {
    // Implement your notification logic here
    print("Notification: $message");
  }
}