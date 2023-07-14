#!/bin/bash

mkdir ~/scr

slurp | grim -g - - | tee ~/scr/$(date -Is).png | wl-copy -t image/png
