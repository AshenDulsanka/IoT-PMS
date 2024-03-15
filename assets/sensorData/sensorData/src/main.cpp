#include <Arduino.h>
#include "wifi/wifi.h"
#include "sensors/sensors.h"
#include "firebase/firebase.h"
#include "mysql/mysql.h"

const int ledPin = 19;

// Provide the token generation process info.
#include "addons/TokenHelper.h"
// Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

WiFiClient client;

// Keep this API Key value to be compatible with the PHP code provided in the project page.
// If you change the apiKeyValue value, the PHP file /post-esp-data.php also needs to have the same key
String apiKeyValue = "tPmAT5Ab3j7F9";

const char *serverName = "https://uptimesensordata.000webhostapp.com/post-esp-data.php";

// Firebase
bool signupOK = false;

// Periodic restart interval (milliseconds)
const unsigned long RESTART_INTERVAL = 10000; // Restart every 5 minutes

// Last restart time
unsigned long lastRestartTime = 0;

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
  unsigned long currentTime = millis();

  // Check if it's time to restart
  if (currentTime - lastRestartTime >= RESTART_INTERVAL) {
    Serial.println("Restarting...");
    delay(100); // Delay to allow serial output to complete
    ESP.restart(); // Restart the device
  }

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

  // You can comment the httpRequestData variable above
  // then, use the httpRequestData variable below (for testing purposes without the BME280 sensor)
  // String httpRequestData = "api_key=tPmAT5Ab3j7F9&sensor=BME280&location=Office&value1=24.75&value2=49.54&value3=1005.14";

  // Send HTTP POST request
  int httpResponseCode = https.POST(httpRequestData);

  // If you need an HTTP request with a content type: text/plain
  // https.addHeader("Content-Type", "text/plain");
  // int httpResponseCode = https.POST("Hello, World!");

  // If you need an HTTP request with a content type: application/json, use the following:
  // https.addHeader("Content-Type", "application/json");
  // int httpResponseCode = https.POST("{\"value1\":\"19\",\"value2\":\"67\",\"value3\":\"78\"}");

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
  // Free resources
  https.end();
  

  Serial.println("--------------------");

  digitalWrite(ledPin, HIGH); // turn on the LED
  delay(500);                 // wait for half a second or 500 milliseconds
  digitalWrite(ledPin, LOW);  // turn off the LED
  delay(500);                 // wait for half a second or 500 milliseconds

  delay(5000); // Wait for 5 seconds before sending next set of sensor values

  // Update last restart time
  lastRestartTime = currentTime;
}
