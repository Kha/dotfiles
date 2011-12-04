#!/bin/sh
xrandr --output LVDS --auto --output HDMI-0 --left-of LVDS --primary --auto --output VGA-0 --left-of LVDS --primary --auto --output DVI-0 --left-of LVDS --primary --auto
xrandr --output VBOX1 --primary --auto --left-of VBOX0
