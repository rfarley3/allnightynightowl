#!/usr/bin/env bash

avrdude -c usbtiny -p t85 -v

echo "NOTE: init failed, rc=-1 means it can talk to programmer, but programmer can't talk to chip" 
# avrdude: initialization failed, rc=-1
# Double check connections and try again, or use -F to override this check.
echo "For more help see: https://learn.adafruit.com/usbtinyisp/help"

