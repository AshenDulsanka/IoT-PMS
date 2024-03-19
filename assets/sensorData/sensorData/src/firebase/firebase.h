#ifndef FIREBASE_H
#define FIREBASE_H

void setupFirebase();
void sendDataToFirebase(double tempValue, int soundValue, int smokeValue, double fuelLvlValue, int vibrationValue, double currentValue, int oilPressureValue);

#endif