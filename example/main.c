#include <Arduino.h>

void init()
{

}

void setup()
{
  Serial.begin(9600);

 pinMode(13, INPUT_PULLUP);
}

void loop()
{
  Serial.println("test");
}


