#include <Arduino.h>
#include <HardwareSerial.h>
#include <SPI.h>

void setup()
{
	Serial.begin( 11520 );
	SPI.begin();
}

void loop()
{
	delay( 1000 );
	Serial.println( "Hello world!" );
}
