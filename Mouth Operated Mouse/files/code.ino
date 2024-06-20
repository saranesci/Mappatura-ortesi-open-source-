/*
  Basic example for the mouth operated mouse project
  based on the 'HID Joystick Mouse Example' by Jim Lindblom (2012)
  by: T. Wirtl
  date: 16/10/2015
  license: MIT License - Feel free to use this code for any purpose.
  No restrictions. Just keep this license if you go on to use this
  code in your future endeavors! Reuse and share.
*/

#include "TimerOne.h"

#define X_AXIS_PIN A0
#define Y_AXIS_PIN A1
#define BUTTON_PIN 2
#define SENSOR_PIN 3

#define TIMER_OVERRUN_USEC 100000  // Timer overrun in usecs (defines the sensitivity of the sensor)
#define AXIS_SENSITIVITY   30      // Higher sensitivity value = slower mouse, should be <= about 500

int vertZero, horzZero;            // Stores the initial value of each axis, usually around 512
int vertValue, horzValue;          // Stores current analog output of each axis


volatile int clickLeft = 0;


// On timer overrun
void timerIrq()
{
  clickLeft = 0; // Let's handle this in the main loop
  Timer1.stop();
}

// On rising edge of the sensor pin
void sensorIrq()
{
  TCNT1 = 1; // Timer restart without triggering the interrupt  
  if (!clickLeft)
  {
    Timer1.start(); // Start the timer if not already started
  }
  clickLeft = 1; // Let's handle this in the main loop
}

void setup()
{
  // Pin config
  pinMode(X_AXIS_PIN, INPUT);      // Set both analog pins as inputs
  pinMode(Y_AXIS_PIN, INPUT);
  pinMode(BUTTON_PIN, INPUT);      // Pin for the connected button
  pinMode(SENSOR_PIN, INPUT);      // Pin for the sensor
  digitalWrite(BUTTON_PIN, HIGH);  // Enable pull-up on button pin (active low)
  
  // Timer initialization
  Timer1.initialize(TIMER_OVERRUN_USEC);
  Timer1.attachInterrupt(timerIrq);
  attachInterrupt(0, sensorIrq, RISING);
  
  // Axis calibration
  delay(1000);                        // short delay to let outputs settle
  vertZero = analogRead(Y_AXIS_PIN);  // get the initial values
  horzZero = analogRead(X_AXIS_PIN);  // Joystick should be in neutral position when reading these

}

void loop()
{
  static int mouseClickFlagRight = 0;
  static int mouseClickFlagLeft = 0;
  
  // Get ADC vals
  vertValue = (analogRead(Y_AXIS_PIN) - vertZero);  // read vertical offset
  horzValue = (analogRead(X_AXIS_PIN) - horzZero);  // read horizontal offset
  
  // Axis movement
  if (vertValue != 0)
  {
    Mouse.move(0, vertValue/AXIS_SENSITIVITY, 0);  // move mouse on y axis
  }
  
  if (horzValue != 0)
  {
    Mouse.move(horzValue/AXIS_SENSITIVITY, 0, 0);  // move mouse on x axis
  } 
  
  // Right mouse button
  if ((digitalRead(BUTTON_PIN) == 0) && (!mouseClickFlagRight))  // if the joystick button is pressed
  {
    mouseClickFlagRight = 1;
    Mouse.press(MOUSE_RIGHT);  // click the left button down
  }
  else if ((digitalRead(BUTTON_PIN))&&(mouseClickFlagRight)) // if the joystick button is not pressed
  {
    mouseClickFlagRight = 0;
    Mouse.release(MOUSE_RIGHT);  // release the left button
  }
  
  // Left mouse button
  if ((clickLeft) && (!mouseClickFlagLeft))  // if the joystick button is pressed
  {
    mouseClickFlagLeft = 1;
    Mouse.press(MOUSE_LEFT);  // click the left button down
  }
  else if ((!clickLeft)&&(mouseClickFlagLeft)) // if the joystick button is not pressed
  {
    mouseClickFlagLeft = 0;
    Mouse.release(MOUSE_LEFT);  // release the left button
  }
  
}
