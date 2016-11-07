/******************************
 * http://www.learningaboutelectronics.com/Articles/ATtiny85-LED-blinker-circuit.php
 ******************************/
#ifndef F_CPU
#define F_CPU 16000000UL // or whatever may be your frequency
#endif

#include <avr/io.h>
#include <util/delay.h>  // for _delay_ms()

int main(void) {
    DDRB = 0xff;  // sets all the pins as outputs
    while(1) {
        PORTB = 0xff;    // set all of PORT B pins as HIGH
        _delay_ms(500);  // keep the port high for 5 seconds
        PORTB = 0x00;    // turn the port off
        _delay_ms(500);  // keep the port off for 5 seconds
    }
}