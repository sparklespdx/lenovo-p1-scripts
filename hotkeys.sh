#!/bin/bash

notify_josh () {
	sudo -u josh DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send "$1" "$2"
}

toggle_cpupower () {
	echo "toggling power profile"
	GOV=$(cpupower frequency-info | grep 'The governor ".*" may decide' | cut -d'"' -f2)

	if [ $GOV == 'powersave' ]; then

    systemctl disable lenovo_fix_powersave
    systemctl enable lenovo_fix_performance
    systemctl start lenovo_fix_performance

		cpupower frequency-set -g performance
		notify_josh "🔥🔥🔥" "CPU Performance Mode Enabled"

	elif [ $GOV == 'performance' ]; then
    systemctl disable lenovo_fix_performance
    systemctl enable lenovo_fix_powersave
    systemctl start lenovo_fix_powersave

		cpupower frequency-set -g powersave
		notify_josh "🐢🐢🐢" "CPU Power Save Mode Enabled"

	fi
}

notify_bluetooth () {
  echo "toggling bluetooth"
	BLUE=$(bluetooth)
	if echo "$BLUE" | grep -q 'on'; then
		notify_josh "🥶🥶🥶" "Bluetooth is turned on"
	elif echo "$BLUE" | grep -q 'off'; then
		notify_josh "☀️☀️☀️" "Bluetooth is turned off"
	fi
}

export -f notify_josh
export -f toggle_cpupower
export -f notify_bluetooth

#evtest /dev/input/by-path/platform-thinkpad_acpi-event |
#  awk '/Event: time.*, type 1 (EV_KEY), code 156 (KEY_BOOKMARKS), value 1/{ system("toggle_cpupower") }'

while true; do
  stdbuf -o0 showkey | \
	  awk '/keycode 156 press/{ system("toggle_cpupower")  }
	       /keycode 237 press/{ system("notify_bluetooth") }'
done
