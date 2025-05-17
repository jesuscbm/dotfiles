#!/usr/bin/env bash
state=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
if [[ "$state" == "yes" ]]; then
    echo "󰂯"
else
    echo "󰂲"
fi
