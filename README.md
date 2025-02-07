# Automatic USB Remounting for Synology VMM

This script checks whether a specific USB device (e.g., ConBee II) is attached to a virtual machine (VM) in **Synology Virtual Machine Manager (VMM)**. If the device is no longer connected, it will be automatically remounted.

## Prerequisites
- Synology NAS with **Virtual Machine Manager (VMM)**
- SSH access to the NAS
- `virsh` commands must be available (KVM/QEMU installed)
- A USB device that should be passed through to a VM

## Installation
1. **Save the script**
   Create a file named `synology-vmm-remount-usb.sh` and save the following script:

   ```bash
   #!/bin/bash
   DEVICE_ID="$VENDOR_ID"
   VM_NAME="$VIRSH_VM_NAME"

   if ! virsh dumpxml "$VM_NAME" | grep -q "$DEVICE_ID"; then
       echo "Remounting USB dongle for VM $VM_NAME..."
       virsh attach-device "$VM_NAME" /var/services/homes/USERNAME/synology/usb_conbee/usb_conbee.xml
   fi
   ```

2. **Make the script executable**
   ```bash
   chmod +x remount_usb.sh
   ```

3. **Set up automatic execution**
   To run the script regularly, add a cron job:
   ```bash
   crontab -e
   ```
   Then add the following line (to check every 5 minutes):
   ```bash
   */5 * * * * /path/to/remount_usb.sh
   ```

## Configuration
### **1. Find the VM name (UUID)**
To find the **UUID** or name of your VM, run:
```bash
virsh list --all
```
Example output:
```
 Id    Name                           State
----------------------------------------------------
 1     HomeAssistant                  running
 -     d25ac3aa-76ff-4bb8-972e-dee62d3f914d shut off
```
You can use either the **UUID or the name** for `VM_NAME` in the script.

### **2. Find the USB Vendor ID and Product ID**
Run the following command on the Synology SSH console:
```bash
lsusb
```
Example output:
```
Bus 001 Device 003: ID 1cf1:0030 Dresden Elektronik ConBee II
```
The values **1cf1 (Vendor ID)** and **0030 (Product ID)** are required in the XML file.

### **3. Create an XML file for the USB device**
Save the following file as `/var/services/homes/USERNAME/synology/usb_conbee/usb_conbee.xml`:

```xml
<hostdev mode='subsystem' type='usb'>
    <source>
        <vendor id='0x1cf1'/>
        <product id='0x0030'/>
    </source>
</hostdev>
```

## Manual USB Remounting
If the script does not run automatically, you can execute it manually:
```bash
./remount_usb.sh
```
If the USB device is not recognized correctly, you can unbind and rebind it:
```bash
echo "1cf1 0030" > /sys/bus/usb/drivers/usb/unbind
sleep 2
echo "1cf1 0030" > /sys/bus/usb/drivers/usb/bind
```

## Troubleshooting
- If `virsh` is not available, ensure that **Virtual Machine Manager** is running.
- If the device is not recognized, check with `lsusb` if it is detected by the NAS.
- Check with `virsh dumpxml VM_NAME | grep hostdev` whether the device is present in the VM XML configuration.

## License
MIT License

