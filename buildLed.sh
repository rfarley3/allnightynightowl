#!/usr/bin/env bash
avr-gcc -g -Os -mmcu=atmega32 -c led.c
avr-gcc -g -mmcu=atmega32 -o led.elf led.o
avr-objcopy -j .text -j .data -O ihex led.elf led.hex

echo "Write to AVR with: avrdude -c usbtiny -p t85 -U flash:w:led.hex"

