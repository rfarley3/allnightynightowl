#!/usr/bin/env bash
NAME=autopress
avr-gcc -g -Os -mmcu=atmega32 -c ${NAME}.c
avr-gcc -g -mmcu=atmega32 -o ${NAME}.elf ${NAME}.o
avr-objcopy -j .text -j .data -O ihex ${NAME}.elf ${NAME}.hex
avrdude -c usbtiny -p t85 -U flash:w:${NAME}.hex
