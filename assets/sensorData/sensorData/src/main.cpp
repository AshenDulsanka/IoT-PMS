#include <Arduino.h>
#include "wifi/wifi.h"
#include "sensors/sensors.h"
#include "firebase/firebase.h"
#include "mysql/mysql.h"

const int ledPin = 19;

// Firebase
bool signupOK = false;

void setup()
{
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(ledPin, OUTPUT); // LED
  connectToWifi();
  setupFirebase();
  setupSensors();
}

void loop()
{
  Serial.println("---------------------");
  if (WiFi.status() != WL_CONNECTED)
  {
    connectToWifi();
  }

  double tempValue = readTempValue();
  int soundValue = readSoundValue();
  int smokeValue = readSmokeValue();
  double fuelLvlValue = readFuelValue();
  int vibrationValue = readVibrationValue();
  int currentValue = readCurrentValue();
  int oilPressureValue = readOilPressureValue();

  Serial.println("--------------------");

  digitalWrite(ledPin, HIGH); // turn on the LED
  delay(500);                 // wait for half a second or 500 milliseconds
  digitalWrite(ledPin, LOW);  // turn off the LED
  delay(500);                 // wait for half a second or 500 milliseconds

  // Firebase
  sendDataToFirebase(tempValue, soundValue, smokeValue, fuelLvlValue, vibrationValue, currentValue, oilPressureValue);

  Serial.println("--------------------");

  // MySQL
  sendDataToMySQL(tempValue, soundValue, smokeValue, fuelLvlValue, vibrationValue, currentValue, oilPressureValue);

  Serial.println("--------------------");

  delay(5000); // Wait for 5 seconds before sending next set of sensor values
}
