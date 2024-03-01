#include <Arduino.h>
// libraries for temp sensor
#include <OneWire.h>
#include <DallasTemperature.h>
// libraries for temp sensor ends here

#define LED 2
int oneWireBus = 34;    // temp sensor
int smoke_digital = 35; // smoke sensor
int sound_digital = 25; // sound sensor

// setting up onewire and dalls for temp sensor
OneWire oneWire(oneWireBus);
DallasTemperature sensors(&oneWire);
// setting up done

void setup()
{
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(sound_digital, INPUT);
  pinMode(smoke_digital, INPUT);
  sensors.begin();
}

void loop()
{
  // put your main code here, to run repeatedly:

  // smoke sensor
  int smokeValue = analogRead(smoke_digital);
  Serial.print("Smoke Value: ");
  Serial.println(smokeValue);
  // smoke sensor ends here

  // temp sensor
  //  Call sensors.requestTemperatures() to issue a global temperature and Requests to all devices on the bus
  sensors.requestTemperatures();

  Serial.print("Celsius temperature: ");
  // Why "byIndex"? You can have more than one IC on the same bus. 0 refers to the first IC on the wire
  Serial.println(sensors.getTempCByIndex(0));
  delay(1000);
  // temp sensor ends here  

  // sound sensor
  int soundValue = analogRead(sound_digital);
  if (soundValue >= 0)
  {
    delay(1000);
    Serial.print("Sound Value: ");
    Serial.println(soundValue);
  }
  // sound sensor ends here
}
