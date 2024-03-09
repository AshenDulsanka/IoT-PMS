#include <Arduino.h>
// libraries for temp sensor
#include <OneWire.h>
// libraries for temp sensor ends here
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

// Provide the token generation process info.
#include "addons/TokenHelper.h"
// Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// network credentials
#define WIFI_SSID "DESKTOP-2PPQP65 7722"
#define WIFI_PASSWORD "982E:56i"

// Insert Firebase project API Key
#define API_KEY "AIzaSyBb0bjuBKrJyziUbjGGXg_dVsGPm4FrZGE"

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://pusl2022-uptime-default-rtdb.asia-southeast1.firebasedatabase.app/"

// Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

WiFiClient client;

const int ledPin = 19;
const int TEMP_PIN = 16;         // temp sensor
const int soundSensorPin = 32;   // sound sensor
const int smokeSensorPin = 35;   // smoke sensor
const int fuelLvlTrigPin = 5;    // fuel level sensor
const int fuelLvlEchoPin = 18;   // fuel level sensor
const int vibSensornPin = 39;    // vibration sensor
const int currentSensorPin = 34; // current sensor
OneWire ds(TEMP_PIN);            // temp sensor

// for fuel level sensor
#define SOUND_SPEED 0.034
#define CM_TO_INCH 0.393701
long fuelLvlDuration;
float FuelLvlDistanceCm;
float fuelLvlDistanceInch;

// for vibration sensor
int buttonState = 0; // variable for reading the pushbutton status

// temp sensor
double readTempValue()
{
  byte i;
  byte present = 0;
  byte type_s;
  byte data[9];
  byte addr[8];
  float celsius, fahrenheit;

  if (!ds.search(addr))
  {
    // Serial.println("No more addresses.");
    // Serial.println();
    ds.reset_search();
    delay(500);
    return readTempValue();
  }

  if (OneWire::crc8(addr, 7) != addr[7])
  {
    Serial.println("CRC is not valid!");
    return -1;
  }

  // the first ROM byte indicates which chip
  switch (addr[0])
  {
  case 0x10:
    // Serial.println("  Chip = DS18S20");  // or old DS1820
    type_s = 1;
    break;
  case 0x28:
    // Serial.println("  Chip = DS18B20");
    type_s = 0;
    break;
  case 0x22:
    // Serial.println("  Chip = DS1822");
    type_s = 0;
    break;
  default:
    Serial.println("Device is not a DS18x20 family device.");
    return -1;
  }

  ds.reset();
  ds.select(addr);
  ds.write(0x44, 1); // start conversion, with parasite power on at the end

  delay(1000); // maybe 750ms is enough, maybe not
  // we might do a ds.depower() here, but the reset will take care of it.

  present = ds.reset();
  ds.select(addr);
  ds.write(0xBE); // Read Scratchpad

  // Serial.print("  Data = ");
  // Serial.print(present, HEX);
  // Serial.print(" ");
  for (i = 0; i < 9; i++)
  { // we need 9 bytes
    data[i] = ds.read();
  }
  // Serial.print(" CRC=");
  // Serial.print(OneWire::crc8(data, 8), HEX);
  // Serial.println();

  // Convert the data to actual temperature
  // because the result is a 16 bit signed integer, it should
  // be stored to an "int16_t" type, which is always 16 bits
  // even when compiled on a 32 bit processor.
  int16_t raw = (data[1] << 8) | data[0];
  if (type_s)
  {
    raw = raw << 3; // 9 bit resolution default
    if (data[7] == 0x10)
    {
      // "count remain" gives full 12 bit resolution
      raw = (raw & 0xFFF0) + 12 - data[6];
    }
  }
  else
  {
    byte cfg = (data[4] & 0x60);
    // at lower res, the low bits are undefined, so let's zero them
    if (cfg == 0x00)
      raw = raw & ~7; // 9 bit resolution, 93.75 ms
    else if (cfg == 0x20)
      raw = raw & ~3; // 10 bit res, 187.5 ms
    else if (cfg == 0x40)
      raw = raw & ~1; // 11 bit res, 375 ms
    //// default is 12 bit resolution, 750 ms conversion time
  }
  celsius = (float)raw / 16.0;
  fahrenheit = celsius * 1.8 + 32.0;
  Serial.print("Temperature: ");
  Serial.print(celsius);
  Serial.print(" Celsius, ");
  Serial.print(fahrenheit);
  Serial.println(" Fahrenheit");
  return celsius;
}
// temp sensor ends here

// fuel level sensor
double readFuelValue()
{
  // Clears the trigPin
  digitalWrite(fuelLvlTrigPin, LOW);
  delayMicroseconds(2);
  // Sets the trigPin on HIGH state for 10 microseconds
  digitalWrite(fuelLvlTrigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(fuelLvlTrigPin, LOW);

  // Measure the duration of the echo pulse
  fuelLvlDuration = pulseIn(fuelLvlEchoPin, HIGH);

  // Calculate the distance
  FuelLvlDistanceCm = (float)fuelLvlDuration * SOUND_SPEED / 2.0;

  // Convert to inches
  fuelLvlDistanceInch = FuelLvlDistanceCm * CM_TO_INCH;

  // Prints the distance in the Serial Monitor
  Serial.print("Distance: ");
  Serial.print(FuelLvlDistanceCm);
  Serial.print(" cm, ");
  Serial.print(fuelLvlDistanceInch);
  Serial.println(" inch");

  return FuelLvlDistanceCm;
}
// fuel level sensor ends here

// sound sensor
int readSoundValue()
{
  int soundValue = analogRead(soundSensorPin);
  Serial.print("Sound Value: ");
  Serial.print(soundValue);
  Serial.println(" dB");
  return soundValue;
}
// sound sensor ends here

// smoke sensor
int readSmokeValue()
{
  int smokeValue = analogRead(smokeSensorPin);
  Serial.print("Smoke Value: ");
  Serial.print(smokeValue);
  Serial.println(" ppm");
  return smokeValue;
}
// smoke sensor ends here

// vibration sensor
int readVibrationValue()
{
  buttonState = analogRead(vibSensornPin);
  Serial.print("Vibration Value: ");
  Serial.print(buttonState);
  Serial.println(" mm/s");
  return buttonState;
}
// vibration sensor ends here

// current sensor
int readCurrentValue()
{
  int currentSensorValue = analogRead(currentSensorPin); // Read the analog pin

  float voltage = currentSensorValue * (3.3 / 4096.0); // Convert analog value to voltage
  float current = (voltage - 2.5) / 0.1;               // Convert voltage to current using ACS712 sensitivity (20A version)

  Serial.print("Voltage: ");
  Serial.print(voltage);
  Serial.print(" V, Current: ");
  Serial.print(current);
  Serial.println(" A");
  return current;
}
// current sensor ends here

// Firebase
bool signupOK = false;

void setup()
{
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(soundSensorPin, INPUT);  // sound sensor
  pinMode(TEMP_PIN, INPUT);        // temp sensor
  pinMode(ledPin, OUTPUT);         // LED
  pinMode(fuelLvlTrigPin, OUTPUT); // fuel level sensor
  pinMode(fuelLvlEchoPin, INPUT);  // fuel level sensor
  pinMode(vibSensornPin, INPUT);   // vibration sensor

  // Connect to Wi-Fi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", ""))
  {
    Serial.println("Firebase signed up successfully");
    signupOK = true;
  }
  else
  {
    Serial.printf("Firebase sign up failed. Error: %s\n", config.signer.signupError.message.c_str());
    return;
  }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop()
{
  Serial.println("--------------------");
  // Read temperature
  double tempValue = readTempValue();
  // temp sensor ends here

  // sound sensor
  int soundValue = readSoundValue();
  // sound sensor ends here

  // smoke sensor
  int smokeValue = readSmokeValue();
  // smoke sensor ends here

  // fuel level sensor
  double fuelLvlValue = readFuelValue();
  // fuel level sensor ends here

  // vibration sensor
  int vibrationValue = readVibrationValue();
  // vibration sensor ends here

  // current sensor
  int currentValue = readCurrentValue();
  // current sensor ends here
  Serial.println("--------------------");

  digitalWrite(ledPin, HIGH); // turn on the LED
  delay(500);                 // wait for half a second or 500 milliseconds
  digitalWrite(ledPin, LOW);  // turn off the LED
  delay(500);                 // wait for half a second or 500 milliseconds

  // Firebase
  // Construct the paths in the Firebase database where you want to store the sensor values
  String tempPath = "sensors/temperature";
  String soundPath = "sensors/sound";
  String smokePath = "sensors/smoke";
  String fuelLvlPath = "sensors/fuel_level";
  String vibrationPath = "sensors/vibration";
  String currentPath = "sensors/current";

  // Send sensor values to the Firebase Realtime Database
  if (Firebase.RTDB.setDouble(&fbdo, tempPath.c_str(), tempValue))
  {
    Serial.println("Temperature value sent to Firebase");
  }
  else
  {
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

  Serial.println("--------------------");

  delay(5000); // Wait for 5 seconds before sending next set of sensor values
}
