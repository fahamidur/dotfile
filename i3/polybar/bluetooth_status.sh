#!/bin/bash

# Simple Bluetooth Status Checker

echo "=== Bluetooth Status ==="

# Check if Bluetooth is powered on
if bluetoothctl show | grep -q "Powered: yes"; then
    echo "Status: 🟢 ENABLED"
    echo ""
    echo "Connected Devices:"
    
    # List connected devices
    bluetoothctl devices Connected | while read -r line; do
        mac=$(echo "$line" | awk '{print $2}')
        name=$(echo "$line" | cut -d' ' -f3-)
        echo "🔹 $name"
        
        # Try to get battery info
        battery=$(bluetoothctl info "$mac" 2>/dev/null | grep "Battery Percentage" | sed 's/.*(\([0-9]*\)%).*/\1/')
        if [[ -n "$battery" ]]; then
            echo "   Battery: $battery%"
        else
            echo "   Battery: Unknown"
        fi
        echo ""
    done
else
    echo "Status: 🔴 DISABLED"
fi
