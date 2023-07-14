#!/bin/bash

mkdir ~/scr

swaymsg -t get_tree | jq -r '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | grim -g - - | tee ~/scr/$(date -Is).png | wl-copy -t image/png
