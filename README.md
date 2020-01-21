# lenovo-p1-scripts

This is a set of scripts for my Lenovo P1 Gen 2.

I am providing a unified PKGBUILD to install the scripts and dependencies for Arch Linux. It is a fork of the throttled package, as I had a need to change the default package's configuration and I am too lazy to split these out into multiple packages.

`hotkeys.sh` and `hotkeys.service` provide a hook to trigger scripted actions based on the Lenovo function keys. These keys do not send descriptive enough ACPI events to trigger off them via acpid and so I am resorting to reading the key presses directly off the input devices.

One of the hooks I am providing is power profile selection via the "star" function key. I have provided a custom package for throttled and the hooks will switch between a "powersave" and "performance" profile for throttled and cpufreq (and whatever else I end up tweaking, perhaps TLP settings.)

`hotkeys.sh` also provides helpful notification messages when Bluetooth and WiFi are turned on and off.
