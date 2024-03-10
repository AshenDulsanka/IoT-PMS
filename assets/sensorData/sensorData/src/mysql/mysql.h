#ifndef MYSQL_H
#define MYSQL_H

#include <Arduino.h>
#include <HTTPClient.h>

void sendDataToMySQL(double tempValue, int soundValue, int smokeValue, double fuelLvlValue, int vibrationValue, int currentValue, int oilPressureValue);

#endif