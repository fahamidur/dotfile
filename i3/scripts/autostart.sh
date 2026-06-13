
# Autostart applications
## Polybar or tint
~/.config/i3/polybar/polybar-i3 &


lxpolkit &
dunst -config ~/.config/i3/dunst/dunstrc &
picom --config ~/.config/i3/picom/picom.conf --animations -b &
# feh --bg-fill ~/wallpaper/wallhaven-9mq26d_3440x1440.png &

# Call your new script on startup to set a wallpaper from the correct folder
~/.config/i3/scripts/wallpaper.sh &

# Kill any existing sxhkd instances first, then start it cleanly
pkill -x sxhkd
sxhkd -c ~/.config/i3/sxhkd/sxhkdrc &
