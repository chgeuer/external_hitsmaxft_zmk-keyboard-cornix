# Cornix German Colemak-DHm Configuration

This document describes the Cornix keyboard configuration that recreates the ZSA Voyager German Colemak-DHm layout with homerow modifiers.

## Overview

The Cornix has been configured with:
- **German Colemak-DHm layout** (Q-W-F-P-B / J-L-U-Y-ß)
- **Homerow modifiers** on A-R-S-T (left) and N-E-I-O (right)
- **German dead key macros** for accent typing
- **4 layers** exactly matching the Voyager layout
- **Encoder functionality** for volume control and mute
- **Bluetooth management** for multiple device switching

## Layer Structure

### Layer 0: Colemak (Base Layer)
```
ESC │  Q  │  W  │  F  │  P  │  B  │                 │  J  │  L  │  U  │  Y  │  ß  │ +   │
TAB │  A  │  R  │  S  │  T  │  G  │                 │  M  │  N  │  E  │  I  │  O  │ #   │
CTRL│  Z  │  X  │  C  │  D  │  V  │                 │  K  │  H  │  ,  │  .  │  -  │SHIFT│
CTRL│ ←   │ →   │BSPC │SPC1 │SnagIt│               │ DEL │SPC2 │ENT │Menu │ ↑   │ ↓   │
```

**Homerow Modifiers:**
- **Left hand:** A(Alt) R(GUI/Win) S(Ctrl) T(Shift)
- **Right hand:** N(Shift) E(Ctrl) I(GUI/Win) O(Alt)

**Special Keys:**
- **SPC1**: Space + Lower layer access
- **SPC2**: Space + Raise layer access
- **SnagIt**: Ctrl+Shift+S (screenshot)
- **Menu**: Windows context menu key
- **Encoder**: Right knob controls volume, push to mute

### Layer 1: Lower (Symbols)
```
^   │  !  │  "  │  $  │  &  │  %  │                 │     │  (  │  )  │  -  │  =  │ \   │
|   │  @  │  ~  │  €  │  +  │  *  │                 │↑WHL │  {  │  }  │  [  │  ]  │ '   │
    │     │  °  │  §  │     │     │                 │↓WHL │  <  │  >  │  :  │  /  │´    │
    │     │     │     │     │     │                 │     │FUNC │     │     │     │ `   │
```

**Dead Key Macros:**
- **^** (circumflex): ESC position - Creates circumflex accent + space
- **´** (acute): Right side middle row - Creates acute accent + space
- **`** (grave): Last key position (under PGDN) - Creates grave accent + space

### Layer 2: Raise (Numbers & Functions)
```
    │  1  │  2  │  3  │  4  │  5  │                 │  6  │  7  │  8  │  9  │  0  │HOME │
    │ F1  │ F2  │ F3  │ F4  │ F5  │                 │ F6  │ ←   │ ↓   │ ↑   │ →   │PGUP │
    │ F7  │ F8  │ F9  │F10  │F11  │                 │F12  │M←   │M↓   │M↑   │M→   │PGDN │
    │     │     │     │FUNC │     │                 │     │BTN1 │BTN2 │     │     │ END │
```

**Mouse Controls:**
- **M←/M↓/M↑/M→**: Mouse movement
- **BTN1/BTN2**: Left/Right mouse clicks

### Layer 3: Adjust (Bluetooth & Media)
```
BTCLR│ BT1 │ BT2 │ BT3 │ BT4 │ BT5 │               │     │VOL+ │PREV │NEXT │     │     │
BTALL│BTDI1│BTDI2│BTDI3│BTDI4│BTDI5│               │     │VOL- │MUTE │PLAY │STOP │     │
SHIFT│     │     │     │SHIFT│BOOT │               │BOOT │  ä  │  ö  │  ü  │  ß  │     │
     │     │     │     │     │     │               │     │     │     │     │     │     │
```

## Bluetooth Management Guide

### Pairing New Devices
1. Access **Layer 3** (hold Lower + Raise simultaneously)
2. Press **BTCLR** to clear current connection
3. Put your device in Bluetooth pairing mode
4. The keyboard will automatically become discoverable

### Managing Multiple Devices (Up to 5)
- **BT1-BT5**: Switch between paired devices instantly
- Each number represents a "profile slot" for a different device
- Example: BT1=Phone, BT2=Laptop, BT3=Tablet, etc.

### Disconnecting vs Unpairing
- **BTDI1-BTDI5**: Temporarily disconnect from profile 1-5 (keeps pairing)
- **BTCLR**: Completely unpair/forget the current connection
- **BTALL**: Nuclear option - unpair ALL devices, start fresh

### Troubleshooting Bluetooth
1. **Connection issues**: Try BTDI then reconnect with BT1-5
2. **Pairing problems**: Use BTCLR to clear, then re-pair
3. **Multiple device conflicts**: Use BTALL to reset everything

## Firmware Updates

### Entering Bootloader Mode
1. Access **Layer 3** (Lower + Raise)
2. Press **BOOT** key
3. Keyboard enters flash mode (appears as USB drive)
4. Copy new `.uf2` firmware file to the drive

### Build Files
- **cornix_left.uf2**: Left side firmware
- **cornix_right.uf2**: Right side firmware
- Both sides need to be flashed with their respective files

### Flashing on Arch Linux

#### Method 1: GUI File Manager (Similar to Windows)
1. **Enter bootloader mode**: Press the physical RESET button on keyboard
2. **Check for auto-mount**: Desktop environment should mount the drive automatically
3. **Copy firmware**: Drag and drop the `.uf2` file to the mounted drive
4. **Auto-eject**: Device will automatically unmount after copying

#### Method 2: Command Line
1. **Enter bootloader mode**: Press the RESET button on the keyboard

2. **Check for the device**:
   ```bash
   lsblk
   # or check system messages
   sudo dmesg | tail
   ```

3. **Mount the device** (if not auto-mounted):
   ```bash
   sudo mkdir -p /mnt/keyboard
   sudo mount /dev/sdb1 /mnt/keyboard  # Replace with your device
   ```

4. **Copy the firmware**:
   ```bash
   # For left side
   sudo cp cornix_left.uf2 /mnt/keyboard/

   # For right side
   sudo cp cornix_right.uf2 /mnt/keyboard/
   ```

5. **Unmount** (device auto-ejects after copying):
   ```bash
   sudo umount /mnt/keyboard
   ```

#### Method 3: Automatic Flash Script
Create a script for easier flashing:

```bash
#!/bin/bash
# Save as flash_keyboard.sh

UF2_FILE="$1"
if [ -z "$UF2_FILE" ]; then
    echo "Usage: $0 <firmware.uf2>"
    exit 1
fi

echo "Put keyboard in bootloader mode (press RESET button)..."
echo "Waiting for bootloader device..."

while true; do
    DEVICE=$(lsblk -o NAME,LABEL | grep "RPI-RP2" | awk '{print "/dev/"$1}')
    if [ ! -z "$DEVICE" ]; then
        echo "Found bootloader device: $DEVICE"

        # Create mount point
        MOUNT_POINT="/tmp/keyboard_flash"
        sudo mkdir -p "$MOUNT_POINT"

        # Mount and copy
        sudo mount "$DEVICE" "$MOUNT_POINT"
        sudo cp "$UF2_FILE" "$MOUNT_POINT/"
        echo "Firmware copied. Device will auto-eject..."

        # Wait for auto-eject
        sleep 2
        sudo umount "$MOUNT_POINT" 2>/dev/null || true
        rmdir "$MOUNT_POINT" 2>/dev/null || true

        echo "Flashing complete!"
        break
    fi
    sleep 1
done
```

**Usage:**
```bash
chmod +x flash_keyboard.sh
./flash_keyboard.sh cornix_left.uf2
# Then repeat for right side
./flash_keyboard.sh cornix_right.uf2
```

### Flashing Process
1. **Flash left side first**: Put left keyboard in bootloader mode, flash `cornix_left.uf2`
2. **Flash right side**: Put right keyboard in bootloader mode, flash `cornix_right.uf2`
3. **Auto-reboot**: Keyboard automatically reboots and loads new firmware
4. **No manual unmount needed**: Bootloader handles ejection automatically

## German Character Support

### Umlauts and Special Characters
Access these through **Layer 3**:
- **ä**: German a-umlaut
- **ö**: German o-umlaut
- **ü**: German u-umlaut
- **ß**: German eszett (also on base layer)

### Dead Key Usage
1. Press dead key (`, ´, or ^) from **Layer 1**
2. Press the vowel you want to accent
3. Examples: ` + a = à, ´ + e = é, ^ + o = ô

## Hardware Features

### Rotary Encoder (Right Side)
- **Turn**: Volume up/down
- **Push**: Mute/unmute

### Split Keyboard Benefits
- **Ergonomic**: Natural hand positioning
- **Wireless**: Bluetooth connectivity to multiple devices
- **Customizable**: Full ZMK firmware programmability

## Configuration Files

### Key Files Modified
- `/config/cornix.keymap`: Main keymap configuration
- `/config/includes/german.h`: German character definitions
- Built with ZMK firmware for nRF52840 controllers

### Layer Access
- **Lower**: Hold left space key
- **Raise**: Hold right space key
- **Adjust**: Hold both Lower + Raise keys simultaneously

## Tips for Daily Use

1. **Homerow mods**: Keep fingers on home row, use holds for modifiers
2. **Dead keys**: Essential for German text - practice the sequences
3. **Bluetooth profiles**: Assign each device to a number for quick switching
4. **Encoder**: Right thumb naturally rests on volume control
5. **Context menu**: Right-click equivalent easily accessible

This configuration provides a powerful, ergonomic typing experience optimized for German text input while maintaining compatibility with multiple devices through Bluetooth.