#!/bin/bash
xrandr --output HDMI-1 --output eDP-1  --same-as HDMI-1
xrandr --output HDMI-1 --mode 1366x768
xrandr --output HDMI-1 --gamma 1.0:1.0:1.0 --brightness 0.5
