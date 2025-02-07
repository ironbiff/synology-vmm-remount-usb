#!/bin/bash
DEVICE_ID="$VENDOR_ID$"
VM_NAME="$VIRSH_VM_NAME$"

if ! virsh dumpxml "$VM_NAME" | grep -q "$DEVICE_ID"; then
    echo "Remounting USB dongle for VM $VM_NAME..."
    virsh attach-device "$VM_NAME" /var/services/homes/$USERNAME$/synology/usb_conbee/usb_conbee.xml
fi
