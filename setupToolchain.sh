#!/usr/bin/env bash
# http://maxembedded.com/2015/06/setting-up-avr-gcc-toolchain-on-linux-and-mac-os-x/
brew tap osx-cross/avr
brew install avr-libc
brew install avrdude --with-usb

