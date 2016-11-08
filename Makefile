.PHONY : install build

NAME := autopress

dist/$(NAME).hex: $(NAME).c
	avr-gcc -g -Os -mmcu=atmega32 -o build/$(NAME).o -c $(NAME).c
	avr-gcc -g -mmcu=atmega32 -o build/$(NAME).elf build/$(NAME).o
	avr-objcopy -j .text -j .data -O ihex build/$(NAME).elf dist/$(NAME).hex

build: dist/$(NAME).hex

install: build
	avrdude -c usbtiny -p t85 -U flash:w:dist/$(NAME).hex
