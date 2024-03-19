#include "firebase.h"
#include <Firebase_ESP_Client.h>

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

void setupFirebase()
{
    // Firebase setup code
    config.api_key = "AIzaSyBb0bjuBKrJyziUbjGGXg_dVsGPm4FrZGE";
    config.database_url = "https://pusl2022-uptime-default-rtdb.asia-southeast1.firebasedatabase.app/";

    if (Firebase.signUp(&config, &auth, "", ""))
    {
        Serial.println("Firebase signed up successfully");
    }
    else
    {
        Serial.printf("Firebase sign up failed. Error: %s\n", config.signer.signupError.message.c_str());
        return;
    }

    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);
}

void sendDataToFirebase(double tempValue, int soundValue, int smokeValue, double fuelLvlValue, int vibrationValue, double currentValue, int oilPressureValue)
{
    // Logic to send data to Firebase
    String tempPath = "sensors/temperature";
    String soundPath = "sensors/sound";
    String smokePath = "sensors/smoke";
    String fuelLvlPath = "sensors/fuel_level";
    String vibrationPath = "sensors/vibration";
    String currentPath = "sensors/current";
    String oilPressurePath = "sensors/oil_pressure";

    Firebase.RTDB.setDouble(&fbdo, tempPath.c_str(), tempValue);
    Firebase.RTDB.setInt(&fbdo, soundPath.c_str(), soundValue);
    Firebase.RTDB.setInt(&fbdo, smokePath.c_str(), smokeValue);
    Firebase.RTDB.setDouble(&fbdo, fuelLvlPath.c_str(), fuelLvlValue);
    Firebase.RTDB.setInt(&fbdo, vibrationPath.c_str(), vibrationValue);
    Firebase.RTDB.setDouble(&fbdo, currentPath.c_str(), currentValue);
    Firebase.RTDB.setInt(&fbdo, oilPressurePath.c_str(), oilPressureValue);
}