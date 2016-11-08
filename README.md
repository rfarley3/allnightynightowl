# All Nighty Night Owl

This project hacks a Cloud B sound machine to play all night (as long as the volume is on). This project has only been tested on the Nighty Night Owl, but it should also work with the Sleep Sheep and other toys that use the same internal sound machine. 

The Cloud B sound machines have a 23 or 45 minute setting. These were not enough for my little one. Worse, it would often go quiet just as she was falling asleep, which would wake her up. Note, that after 2015-ish, Cloud B added a tilt/motion sensor that resumes playing if a baby moves the toy. But if you're here, then you probably don't have one of those or even that is not good enough.

## Intro

We are going to program a microcontroller to mimick repeatedly pressing the same sound button to restart the sounds as soon as possible after it stops. The fake button press will happen frequently enough that there will only ever be at max 1 second of silence between loops (every 45 minutes).

This project is a minimal viable solution. It will require you to choose a single sound that will always be on whenever the volume is on. It is completely reversible and runs in parallel to the existing parts. In fact, if you add a power switch to the AVR, then this always-on mode could be disabled without opening up the sound machine.

### Ugh, Microcontroller?!

You might be able to avoid an AVR completely. I happened to have an AVR with a programmer, so my choice was easy. My first non-AVR idea is some 555 magic to peridically emit high, or toggle a mosfet or relay. Don't ask me how though... 

The second non-AVR idea is adding a physical switch that can detect movement and use it to bridge (in parallel to) one of the sound buttons. This would mimicking what the current versions do (requiring the little one to move it to demand more noise). Take for instance, this $2 (solution)[https://www.adafruit.com/product/173]. However, there'd be no guarantee that the ball wouldn't stay on the switch all night, and while this probably doesn't matter to the IC, it may. Also, you would still be locked into a single sound.

## Background

The sound machine has 4 buttons to select the sound, an on/off/volume knob, and a timer-select switch to set the timer for either 23 or 45 minutes. There is no power to its IC when the volume knob is off. It does not begin playing until a sound button is pressed. The timer is an estimate, I've observed anywhere between 23:25-23:50 when set on 23.

Changing the timer-select switch does not reset the timer. When a button is pressed, whatever the timer-select switch is on is the length of time played. For instance, if you press Ocean with the switch on 23, then wait 2 minutes, then change the switch to 45, it will only play for 23.

Pressing the same sound button after it stops will replay that sound. For instance, if you press Ocean with the timer set to 23, wait for the sound to stop (roughly 23 minutes later), then press Ocean with the timer set to 23, then you will hear 23 minutes of Ocean.

Pressing the same button twice does not reset the timer. The only way to reset the timer is to press another sound button. For instance, if you press Ocean with the timer set to 23, then wait 2 minutes, then press Whales with the timer set to 23, then you will hear 23 minutes of Whales.

This means that the only way to reset the timer is to press a button, and there are two options for this:
1) Press a sound while no sound is playing
2) Rotate through a set of the sounds

## Method

To stay as simple as possible, I chose 1 (Press a sound while no sound is playing). 2 (Rotate through a set of the sounds) would prevent any break in sound, but would require more wires, and I'm not sure how my little one would do with the changing noises.

You can simulate a button press by jumping the voltage that runs from the IC to the buttons, called a 4Key, so call this voltage Vkey (it's marked with a + on the main IC board and leads to a red wire), to any of the 4 button inputs (4 posts next to the +, all with white wires). Try it out. While you're there, choose what post matches up with the sound you want to choose to hear all night.

Since the timer varies slightly, and the AVR clock is not in sync with the machine's clock, we can not sleep for 23:01. Instead, we'll just press the button every second. This means that the longest the machine will be quiet for is 1 second. Note, that the AVR seems to have a small boot up time and you may notice that it'll take up to 2 seconds when it first turns on.

### Assemble all the things

You will need:
* Cloud B sound machine
* AVR microcontroller
    * ATtiny85
* AVR programmer
    * USBTinyISP2 from Adafruit
    * A way to connect the 6 pin cable to the ATtiny
        * Like a breadboard and jumper cables
* Soldering iron
* Spare wire

### Programming

The AVR executes a small loop that sleeps for 1 second, then emits a 0.2 second high signal (to the IC input that matches the post of the white wire that runs from the button of sound you choose). You can see the source in `autopress.c`. For ease, I've included it compiled (well, actually, the hex that you can burn to an ATtiny85) as `dist/autopress.hex`. 

Before you can burn the hex, you need to connect the ATtiny85 to the USBTinyISP2. I used a breadboard and followed the pin outs in `docs/pinouts.png` and `docs/usbtinyisp2attiny85.txt`. You'll also need `avrdude`; here's how I installed it on my OS X box:
```
brew install avrdude --with-usb`
```

To burn the hex, run `avrdude -c usbtiny -p t85 -U flash:w:dist/autopress.hex`.

If you want to modify the source, then you will need a build toolchain. For Linux and Mac, install `gcc-avr`. For help setting up your toolchain, go (here)[http://maxembedded.com/2015/06/setting-up-avr-gcc-toolchain-on-linux-and-mac-os-x/]. Here's how I installed it on my OS X box:
```
brew tap osx-cross/avr
brew install avr-libc
```

Once your build environment is ready to go, you can modify `autopress.c` and cross-compile it with `make build`. If the USBTinyISP2 and ATtiny85 are hooked up, then you can burn the built hex with `make install`.

### Wiring it up

To keep things as simple as possible, let's do this in 3 connections. Refer to `docs/pinouts.png` for an image of the AVR pins. First, solder a post associated with a single sound (solder directly, or with wire) to PWM0/PB0 (pin 5) on the AVR.

Second, power the AVR from the buttons' input post, called Vb (b for buttons). This is the post connected to a red wire, marked with a `+`. It contains the voltage that runs from the IC to the buttons and it is the same as the batteries ~3V (i.e., Vin of the IC, Vout from the speaker switch). This works because the ATtiny 45 can be powered from 2.7-5.5V. Connect (solder directly, or with wire) Vb to VCC (pin 8) on the AVR.

Third, connect ground on the AVR (GND, pin 4) to the batteries' ground terminal (the black wire).

## Future

I'd like to add a switch to turn it off. Since the AVR runs in parallel to the buttons, a simple on-off switch in series to the AVR voltage input or ground would allow you to return it back to factory without taking anything apart.

I'd also like to add a switch to control which sound is autopressed. With a 4-way switch a single port on the AVR could be redirected to any of the sound buttons. 

Finally, since it'll be playing much longer every night, adding a power input (for wall or USB) would be a huge benefit.
