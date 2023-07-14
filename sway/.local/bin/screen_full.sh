#!/bin/bash

mkdir ~/scr

grim - | tee ~/scr/$(date -Is).png | wl-copy -t image/png
