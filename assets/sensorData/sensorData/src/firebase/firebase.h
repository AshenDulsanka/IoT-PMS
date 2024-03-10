#ifndef FIREBASE_H
#define FIREBASE_H

// Provide the token generation process info.
#include "addons/TokenHelper.h"
// Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

void setupFirebase();
void sendDataToFirebase(double tempValue, int soundValue, int smokeValue, double fuelLvlValue, int vibrationValue, int currentValue, int oilPressureValue);

#endif