#!/bin/bash
x=$1
y=852
z=$((x*y))
w=100
ans=$((z / w))
sudo su -c "echo $ans >/sys/class/backlight/intel_backlight/brightness"