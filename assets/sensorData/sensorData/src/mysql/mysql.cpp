#include "mysql.h"

const String URL = "https://uptimesensordata.000webhostapp.com/post-esp-data.php";

void sendDataToMySQL(double tempValue, int soundValue, int smokeValue, double fuelLvlValue, int vibrationValue, int currentValue, int oilPressureValue)
{
    String postData = "temp=" + String(tempValue) + "&sound=" + String(soundValue) + "&smoke=" + String(smokeValue) + "&fuelLvl=" + String(fuelLvlValue) + "&vibration=" + String(vibrationValue) + "&current=" + String(currentValue) + "&oilPressure=" + String(oilPressureValue);
    HTTPClient http;
    http.begin(URL);
    http.addHeader("Content-Type", "application/x-www-form-urlencoded");

    int httpCode = http.POST(postData);
    String payload = http.getString();

    Serial.print("HTTP Code: ");
    Serial.println(httpCode);
}