#!/bin/bash
DEVICE_ID="VENDOR_ID" #like 1cf1 
VM_NAME="VIRSH_NAME" #like d25ac3aa-76ff-4bb8-972e-dee62d3f914d

if ! virsh dumpxml d25ac3aa-76ff-4bb8-972e-dee62d3f914d | grep -q "$DEVICE_ID"; then
#    echo "USB-Dongle nicht gefunden. Versuche, ihn erneut zu verbinden..."
#    synoservice --restart synousbservice
    echo "Dongle erneut mounten für VM $VM_NAME..."
    virsh attach-device "$VM_NAME" /var/services/homes/ironbiff/synology/usb_conbee/usb_conbee.xml
fi
