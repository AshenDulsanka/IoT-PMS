#include <Arduino.h>

#define LED 2
int sound_digital = 33;

void setup()
{
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(LED, OUTPUT);
  pinMode(sound_digital, INPUT);
}

void loop()
{
  // put your main code here, to run repeatedly:

  // write the value of the digital pin to the serial monitor

  int soundValue = analogRead(sound_digital);
  if (soundValue > 0)
  {
    delay(1000);
    Serial.println(soundValue);
  }
}