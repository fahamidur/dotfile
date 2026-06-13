#!/bin/bash

# Define the correct path to your wallpaper directory
WALLPAPER_DIR="$HOME/.config/i3/wallpaper"

# Tell feh to pick a random wallpaper from that folder and apply it
feh --bg-fill --randomize "$WALLPAPER_DIR"/*
