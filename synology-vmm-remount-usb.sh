#!/bin/bash

# Vendor ID of the USB device (ConBee II)
DEVICE_ID="1cf1"

# Extract the VM ID (UUID) of the VM with title "DSM instance: homeassistant"
VM_NAME=$(virsh list --title | grep 'DSM instance: homeassistant' | awk '{print $2}')

# Optional: Print the VM name (UUID) for debugging
echo "Detected VM: $VM_NAME"

# Check if VM_NAME was successfully found
if [ -z "$VM_NAME" ]; then
    echo "Error: HomeAssistant VM not found!"
    exit 1
fi

# Check if the USB device is already attached to the VM
if ! virsh dumpxml "$VM_NAME" | grep -q "$DEVICE_ID"; then
    echo "USB dongle not attached – attempting to mount..."
    virsh attach-device "$VM_NAME" /var/services/homes/ironbiff/synology/usb_conbee/usb_conbee.xml
else
    echo "USB dongle already attached. No action taken."
fi
