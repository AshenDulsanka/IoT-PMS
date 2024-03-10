#include "firebase.h"
#include <Firebase_ESP_Client.h>

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

void setupFirebase() {
    // Firebase setup code
    config.api_key = "AIzaSyBb0bjuBKrJyziUbjGGXg_dVsGPm4FrZGE";
    config.database_url = "https://pusl2022-uptime-default-rtdb.asia-southeast1.firebasedatabase.app/";

    if (Firebase.signUp(&config, &auth, "", "")) {
        Serial.println("Firebase signed up successfully");
    } else {
        Serial.printf("Firebase sign up failed. Error: %s\n", config.signer.signupError.message.c_str());
        return;
    }

    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);
}

void sendDataToFirebase(double tempValue, int soundValue, int smokeValue, double fuelLvlValue, int vibrationValue, int currentValue, int oilPressureValue) {
    // Logic to send data to Firebase
    String tempPath = "sensors/temperature";
    String soundPath = "sensors/sound";
    String smokePath = "sensors/smoke";
    String fuelLvlPath = "sensors/fuel_level";
    String vibrationPath = "sensors/vibration";
    String currentPath = "sensors/current";
    String oilPressurePath = "sensors/oil_pressure";

    if (Firebase.RTDB.setDouble(&fbdo, tempPath.c_str(), tempValue)) {
        Serial.println("Temperature value sent to Firebase");
    } else {
        Serial.println("Failed to send temperature value to Firebase");
    }

    if (Firebase.RTDB.setInt(&fbdo, soundPath.c_str(), soundValue))
  {
    Serial.println("Sound value sent to Firebase");
  }
  else
  {
    Serial.println("Failed to send sound value to Firebase");
  }

  if (Firebase.RTDB.setInt(&fbdo, smokePath.c_str(), smokeValue))
  {
    Serial.println("Smoke value sent to Firebase");
  }
  else
  {
    Serial.println("Failed to send smoke value to Firebase");
  }

  if (Firebase.RTDB.setDouble(&fbdo, fuelLvlPath.c_str(), fuelLvlValue))
  {
    Serial.println("Fuel level value sent to Firebase");
  }
  else
  {
    Serial.println("Failed to send fuel level value to Firebase");
  }

  if (Firebase.RTDB.setInt(&fbdo, vibrationPath.c_str(), vibrationValue))
  {
    Serial.println("Vibration value sent to Firebase");
  }
  else
  {
    Serial.println("Failed to send vibration value to Firebase");
  }

  if (Firebase.RTDB.setInt(&fbdo, currentPath.c_str(), currentValue))
  {
    Serial.println("Current value sent to Firebase");
  }
  else
  {
    Serial.println("Failed to send current value to Firebase");
  }

  if (Firebase.RTDB.setInt(&fbdo, oilPressurePath.c_str(), oilPressureValue))
  {
    Serial.println("Oil pressure value sent to Firebase");
  }
  else
  {
    Serial.println("Failed to send oil pressure value to Firebase");
  }
}