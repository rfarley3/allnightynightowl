# All Nighty Night Owl

The Cloud B series sleep sound machines have a 23 or 45 minute setting. These can easily not be enough for a baby, or worse stop just as they are falling asleep. Their current versions have a motion sensor to resume if a baby wakes and moves them; but their old ones (<=2015-ish) do not.

This project provides the instructions and code to hack the Cloud B sound machines to play as long as the volume is on. It has only been tested on the Nighty Night Owl. This version is a minimal viable solution, and will require you to choose a single sound, that will always be on whenever the machine is on. It is completely reversible and runs in parallel to the existing parts.

## All the things

You'll need:
* Cloud B sound machine
* AVR microcontroller
    * ATtiny85
* AVR programmer
    * USBTinyISP2 from Adafruit
    * Plus way to connect the 6 pin cable to the ATtiny
        * Like a breadboard and jumper cables
* Soldering iron
* Three 3" wires

## Just the Facts

The box has 4 buttons to select the sound, an on/off/volume knob, and a switch to set the timer for 23 or 45 minutes. There is no power to the IC when the volume knob is off. It does not begin playing until a sound button is pressed. The timer is an estimate, I've observed anywhere between 23:25-23:50 when set on 23.

Changing the timer select switch does not reset the timer. When a button is pressed, whatever the timer select switch is on is the time that will play. For instance, if you press Ocean with the switch on 23, then even if you change the switch to 45 after the sound begins, it will only play for 23.

Pressing the same button after it stops will replay that sound. For instance, if you press Ocean with the timer set to 23, wait for the sound to stop (roughly 23 minutes later), then press Ocean with the timer set to 23, then you will hear 23 minutes of Ocean.

Pressing the same button twice does not reset the timer. The only way to reset the timer is to press another sound button. For instance, if you press Ocean with the timer set to 23, then wait 2 minutes, then press Whales with the timer set to 23, then you will hear 23 minutes of Whales.

## How to Infinite Loop

This means that the only way to reset the timer is to press a button, and there are two options for this:
1) Press a sound while no sound is playing
2) Rotate through a set of the sounds

To stay as simple as possible, I chose 1. 2 would require more wires, and I'm not sure how my little one would do with the noise change. 

You can simulate a button press by jumping the voltage that runs from the IC to the buttons, called a 4Key, so call this voltage Vkey (it's marked with a + on the main IC board and leads to a red wire), to any of the 4 button inputs (4 posts next to the +, all with white wires). Try it out.

Since the timer varies slightly, and the AVR clock is not in sync with the machine's clock, we can not sleep for 23:01. Instead, we'll just press the button every half second for 0.2 seconds. This means that the longest the machine will be quiet for is 0.7 seconds. I have not field tested this yet.

## Programming

Use gcc-avr to cross compile a tiny C program (hex included in this repo). And then use avrdude (via brew on Mac OS X) to write the AVR. I used an USBTinyISP2 to write the AVR over USB, and a bread board to connect the UTI2's 6 wire cable to the AVR. All compile and write scripts included in this repo.

## Wiring it up

To keep things as simple as possible, let's do this in 3 wires. First, solder a wire to a post associated with a single sound, and connect the other side of it to PWM0/PB0 (pin 5) on the AVR.

Second, power the AVR from the Vbuttons post. This is the post connected to a red wire, marked with a `+`. It contains the voltage that runs from the IC to the buttons and it is the same as the batteries ~3V (i.e., Vin of the IC, Vout from the speaker switch). This works because the ATtiny 45 can be powered from 2.7-5.5V. Solder a wire from Vbuttons to VCC (pin 8) on the AVR.

Third, solder a wire from ground on the AVR (GND, pin 4) to the batteries' ground terminal (the black wire).

## Future

I'd like to add a switch to control which sound is autopressed. With a 4-way switch a single port on the AVR could be redirected to any of the sound buttons. 

I'd also like to add a switch to turn it off. Since the AVR runs in parallel to the buttons, a simple on-off switch in series to the AVR voltage input or ground would allow you to return it back to factory.

Finally, since it'll be playing 6-10x longer every night, adding a power input for wall or USB would be a huge benefit.

## Ugh, Microcontroller?!

You could avoid a microcontroller completely with possible some 555 (peridically emit high, or toggle a mosfet or relay). Don't ask me how though. I happened to have an AVR with a programmer.

Also, I had the though of adding a physical switch that can detect movement. This would mimicking what the current version do, by requiring the little one to move it to demand more noise. Take for instance, this $2 (solution)[https://www.adafruit.com/product/173]. However, there'd be no guarantee that the ball wouldn't stay on the switch all night, and while this probably doesn't matter to the IC, it may.
