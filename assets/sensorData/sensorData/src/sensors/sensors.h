#ifndef SENSORS_H
#define SENSORS_H

void setupSensors();
double readTempValue();
double readFuelValue();
int readSoundValue();
int readSmokeValue();
int readVibrationValue();
int readCurrentValue();
int readOilPressureValue();

#endif