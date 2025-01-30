#include <Arduino.h>
#include "wifi/wifi.h"
#include "sensors/sensors.h"
#include "firebase/firebase.h"
#include "mysql/mysql.h"

const int ledPin1 = 4;
const int ledPin2 = 2;
const int ledPin3 = 19;

// Provide the token generation process info.
#include "addons/TokenHelper.h"
// Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

WiFiClient client;

String apiKeyValue = "";

const char *serverName = "https://uptimesensordata.000webhostapp.com/post-esp-data.php";

// Firebase
bool signupOK = false;

// Periodic restart interval (milliseconds)
const unsigned long RESTART_INTERVAL = 15000; // Restart every 15 seconds

// Last restart time
unsigned long lastRestartTime = 0;

void setup()
{
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(ledPin1, OUTPUT); // LED
  pinMode(ledPin2, OUTPUT); // LED
  pinMode(ledPin3, OUTPUT); // LED
  digitalWrite(ledPin1, LOW); 
  digitalWrite(ledPin2, LOW); 
  digitalWrite(ledPin3, LOW); 
  connectToWifi();
  setupFirebase();
  setupSensors();
}

void loop()
{
  unsigned long currentTime = millis();

  // Check if it's time to restart
  if (currentTime - lastRestartTime >= RESTART_INTERVAL)
  {
    Serial.println("Restarting...");
  delay(100);    // Delay to allow serial output to complete
  ESP.restart(); // Restart the device
  }

  Serial.println("---------------------");
   // Check WiFi connection
  if (WiFi.status() == WL_CONNECTED)
  {
    digitalWrite(ledPin2, HIGH); // Turn on blue LED for WiFi connected
    digitalWrite(ledPin3, LOW);  // Turn off red LED
  }
  else
  {
    digitalWrite(ledPin2, LOW);  // Turn off blue LED for WiFi disconnected
    digitalWrite(ledPin3, HIGH); // Turn on red LED to indicate error
  }

  double tempValue = readTempValue();
  int soundValue = readSoundValue();
  int smokeValue = readSmokeValue();
  double fuelLvlValue = readFuelValue();
  int vibrationValue = readVibrationValue();
  double currentValue = readCurrentValue();
  int oilPressureValue = readOilPressureValue();

  Serial.println("--------------------");

  // Handle LED states based on sensor readings
  if (tempValue != -1 && soundValue != -1 && fuelLvlValue != -1 && vibrationValue != -1 && currentValue != -1 && oilPressureValue != -1 && smokeValue != -1)
  {
    digitalWrite(ledPin1, HIGH); // Turn on green LED if all sensor readings are okay
  }
  else
  {
    digitalWrite(ledPin1, LOW); // Turn off green LED if any sensor reading is invalid
  }

  // Firebase
  sendDataToFirebase(tempValue, soundValue, smokeValue, fuelLvlValue, vibrationValue, currentValue, oilPressureValue);

  Serial.println("--------------------");

  // MySQL
  WiFiClientSecure *client = new WiFiClientSecure;
  client->setInsecure(); // don't use SSL certificate
  HTTPClient https;

  // Your Domain name with URL path or IP address with path
  https.begin(*client, serverName);

  // Specify content-type header
  https.addHeader("Content-Type", "application/x-www-form-urlencoded");

  // Prepare your HTTP POST request data
  String httpRequestData = "api_key=" + apiKeyValue +
                           "&vibration=" + String(vibrationValue) +
                           "&temprature=" + String(tempValue) +
                           "&fuelLevel=" + String(fuelLvlValue) +
                           "&oilPressure=" + String(oilPressureValue) +
                           "&current=" + String(currentValue) +
                           "&sound=" + String(soundValue) +
                           "&gas=" + String(smokeValue);

  // Send HTTP POST request
  int httpResponseCode = https.POST(httpRequestData);

  if (httpResponseCode > 0)
  {
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);
  }
  else
  {
    Serial.print("Error code: ");
    Serial.println(httpResponseCode);
  }
  https.end();

  Serial.println("--------------------");

  delay(5000); // Wait for 5 seconds before sending next set of sensor values

  // Update last restart time
  lastRestartTime = currentTime;
}
