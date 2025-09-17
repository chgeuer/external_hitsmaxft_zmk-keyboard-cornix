#!/bin/bash
# Flash script for Cornix keyboard firmware on Arch Linux
# Usage: ./flash_keyboard.sh <firmware.uf2>

UF2_FILE="$1"
if [ -z "$UF2_FILE" ]; then
    echo "Usage: $0 <firmware.uf2>"
    echo "Example: $0 cornix_left.uf2"
    exit 1
fi

if [ ! -f "$UF2_FILE" ]; then
    echo "Error: File '$UF2_FILE' not found!"
    exit 1
fi

echo "================================================"
echo "Cornix Keyboard Firmware Flash Script"
echo "================================================"
echo "Firmware file: $UF2_FILE"
echo ""
echo "Instructions:"
echo "1. Connect your keyboard via USB cable"
echo "2. Press the physical RESET button on the keyboard"
echo "3. The keyboard will enter bootloader mode"
echo ""
echo "Put keyboard in bootloader mode (press RESET button)..."
echo "Waiting for bootloader device..."

while true; do
    # Look for common bootloader labels (RPI-RP2, cornix, or other RP2040 boards)
    DEVICE=$(lsblk -o NAME,LABEL | grep -E "(RPI-RP2|cornix|RP2040)" | awk '{print "/dev/"$1}')
    if [ ! -z "$DEVICE" ]; then
        echo "Found bootloader device: $DEVICE"

        # Create mount point
        MOUNT_POINT="/tmp/keyboard_flash"
        sudo mkdir -p "$MOUNT_POINT"

        # Mount and copy
        echo "Mounting device..."
        sudo mount "$DEVICE" "$MOUNT_POINT"

        echo "Copying firmware..."
        sudo cp "$UF2_FILE" "$MOUNT_POINT/"

        echo "Firmware copied. Device will auto-eject..."

        # Wait for auto-eject
        sleep 2
        sudo umount "$MOUNT_POINT" 2>/dev/null || true
        rmdir "$MOUNT_POINT" 2>/dev/null || true

        echo "================================================"
        echo "Flashing complete!"
        echo "The keyboard will automatically reboot and load"
        echo "the new firmware."
        echo "================================================"
        break
    fi
    sleep 1
done