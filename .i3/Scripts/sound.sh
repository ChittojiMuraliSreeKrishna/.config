#!/bin/sh
#
# volume (display main volume, mute on right click and change on scroll)
#

case $BLOCK_BUTTON in
  1) pactl set-sink-mute @DEFAULT_SINK@ toggle ;; # right click : toggle mute
  4) pactl set-sink-volume @DEFAULT_SINK@ +2% ;; # scroll up : increase vol by 2%
  5) pactl set-sink-volume @DEFAULT_SINK@ -2% ;; # scroll down : decrease vol by 2%
esac

sinks=$(pactl list sinks)
isbluetooth=$(echo "$sinks" | grep bluez)
isheadphone=$(echo "$sinks" | grep "Active Port: analog-output-headphone")
ismuted=$(echo "$sinks" | grep "Mute: " | tail -1 | awk '{print $2}')
volume=$(echo "$sinks" | grep "Volume: " | tail -2 | head -1 | awk '{print $5}' | tr -d '%')

if [ -n "$isbluetooth" ]; then
  color="#1E88E5"
  if [ "$ismuted" = "yes" ]; then
    color="#997CC5"
  fi
elif [ -n "$isheadphone" ]; then
  color="#00A900"
  if [ "$ismuted" = "yes" ]; then
      color="#A90000"
  fi
elif [ "$ismuted" = "yes" ]; then
  color="#A0A0A0"
else
  color="#dddddd"
fi

printf "<span color='%s'>" "$color"

if [ "$ismuted" = "yes" ]; then
  printf "<s> "
fi
if [ -n "$isbluetooth" ]; then
  printf "<span fallback='true'>  </span>"
fi
if [ "$volume" -ge 40 ]; then
  printf "<span fallback='true'>  </span>%s" "$volume"
else
  printf "<span fallback='true'>  </span>%s" "$volume"
fi

printf "<small>%%</small>"

if [ "$ismuted" = "yes" ]; then
  printf " </s>"
fi

echo "</span>"
