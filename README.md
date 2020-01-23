# lenovo-p1-scripts

This is a set of scripts for my Lenovo Thinkpad P1 Gen 2 and my documentation of configuration changes to support Linux on the laptop.

This information probably also applies to the Thinkpad X1 Extreme Gen 2 and may possibly apply to other similar platforms from other vendors.

## Packaging / Support

I use Arch Linux, so, that's what this repo supports.

I am including a PKGBUILD that installs all the scripts and configurations, including a slightly modified version of the Arch Linux throttled package. This is mostly for my own use.

All of the things in this repo should work other distros. Probably.

## Hybrid Graphics

This laptop supports native D3 power management and PRIME offload rendering in X11. After 12+ years, NVIDIA is finally supporting real hybrid graphics on Linux.

https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/primerenderoffload.html
https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/dynamicpowermanagement.html

The driver will shut down the card into D3 Cold state and bring it back when a process asks for it. This seems to be stable.

I have included the necessary configuration for the `nvidia` module and a shell script called `gpuwrap.sh` that provides the required environment variables for PRIME offloading, i.e. `/usr/bin/gpuwrap.sh glmark2`.

__Note:__ In order for PRIME offloading to work, you need to provide a suitable X11 configuration as described in the NVIDIA readme. I am using the "hybrid mode" configuration from optimus-manager: https://github.com/Askannz/optimus-manager. This package does not include an X11 config.

## Thermal Throttling / Power Management

From the factory, the Thinkpad P1 Gen 2 (and Thinkpad X1 Extreme Gen 2) have very aggressive power throttling enabled at the BIOS level. The system seems to begin power throttling at 45 watts TDP after updating past BIOS version 1.26. Before then, it was even worse.

The fans also seem to be throttled by default. They spin up to approx. 4500 RPM, when their actual maximum is 5500RPM when exposed via the `thinkpad_acpi` kernel module.

This results in a system that is quiet and cool to the touch under sustained full load. The CPU package does not get over 75\*C, you can barely hear the fans, and the system is very easy to have on your lap. One can only assume this was the manufacturer's intent when setting these limits. It also makes sense that they would try to account for the added heat from the GPU.

However, these settings result in severly reduced clock speeds when under sustained load. It is disappointing for a system with a late-model i9 processor to consistently run under its base clock speed. The bottleneck is TDP power throttling set by the BIOS. The desired configuration is to have the motherboard push as much power as the CPU can take and only begin throttling when the CPU hits a specified thermal limit. I have chosen to push this to 85\*C, about 10\* hotter than the factory. I have pushed this to 90\*C and 95\*C in testing. 90\*C is stable on my system at the provided voltage offsets, but the laptop does get very hot. At 95\*C processes will start throwing random segfaults.

My approach to this problem was:
* Used throttled to manually configure TDP and Temperature throttling limits based on AC vs Battery power and a manual power profile toggle.
* Created a service that monitors fan speed and CPU temperature and boosts the fan speed to maximum under heavy load.
* Set a negative voltage offset via thermald.

The CPU is able to push close to 60 watts in this configuration and the fan booster contributes to more stable frequencies over long and heavy loads. The increased fan speed also helps with getting rid of waste heat from high GPU loads. The GPU being spun up does not seem to significantly impact the clock frequency until waste heat really stars to build up.

The package installs thermald from source and provides configurations for it, as well as a hook into hotkeys.sh to trigger manual power profile switching as needed.

__I do not guarantee that my power settings will not damage your system or void your warantee. Use at your own risk.__

TODO: Provide data on performance gains

## Hotkeys.sh

This is a script that reads key presses off of `showkey` and looks for the Fn + F12 key and Fn + F11 key. You can trigger custom actions based on these keys. They don't send up distinct ACPI events, so this is what I resorted to. I've included a service definition.

GNOME provides Bluetooth and Wifi toggle messages, but Cinnamon doesn't. I've included those as well for other desktop environments.
