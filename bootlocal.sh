#!/bin/sh

# Set CPU frequency governor to ondemand (default is performance)
echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# Load modules - i2c-dev needs manually loaded even if enabled in config.txt
#/sbin/modprobe i2c-dev
/sbin/modprobe fb_ili9340

# Wait fb1 to be ready
counter=0
while [ ! -e /dev/fb1 ]; do
    sleep .5
    counter=$((counter + 1))
    if [ $counter -ge 10 ]; then
        break
    fi
done
# End wait

# Mirror fb0 to fb1
fbcp&

# Start openssh daemon
su tc -c "tce-load -i openssh"
/usr/local/etc/init.d/openssh start

# ------ Put other system startup commands below this line
su tc -c "tce-load -i wireless-5.10.77-piCore"
su tc -c "tce-load -i firmware-rpi-wifi"
su tc -c "tce-load -i wifi"
wifi.sh -a 2>&1 > /tmp/wifi.log

