#ifndef F_CPU
#define F_CPU 16000000UL // or whatever may be your frequency
#endif
 
#include <avr/io.h>
#include <util/delay.h>                // for _delay_ms()
 
// int main(void)
// {
//     DDRC = 0x01;                       // initialize port C
//     while(1)
//     {
//         // LED on
//         PORTC = 0b00000001;            // PC0 = High = Vcc
//         _delay_ms(500);                // wait 500 milliseconds
 
//         //LED off
//         PORTC = 0b00000000;            // PC0 = Low = 0v
//         _delay_ms(500);                // wait 500 milliseconds
//     }
// }

int main(void) {
    DDRB= 0xff; // sets all the pins as outputs
    while(1) {
        PORTB= 0xff;  // set all of PORT B pins as HIGH
        _delay_ms(500);  // keeps the LED on for a half a second
        PORTB= 0x00;  // turns the LED off
        _delay_ms(500);  // keeps the LED off for a half a second
    }
}