# Cornix Keyboard Build Guide

Complete setup guide for building ZMK firmware for the Cornix split ergonomic keyboard on Arch Linux.

## Fresh Arch Linux Setup

### 1. Install Required Packages
```bash
# Core development tools and dependencies
sudo pacman -S base-devel git cmake ninja dtc python python-pip wget xz dfu-util
```


### 2. Install Compatible Zephyr SDK
Based on the Zephyr 3.5.0 CI configuration, this repository expects SDK 0.16.3:

```bash
set -euo pipefail

ZEPHYR_VERSION="0.16.3"
ZEPHYR_FILE="zephyr-sdk-${ZEPHYR_VERSION}_linux-x86_64.tar.xz"
ZEPHYR_GH_URL="https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_VERSION}/${ZEPHYR_FILE}"
ZEPHYR_INSTALL="$HOME/zephyr-sdk-${ZEPHYR_VERSION}"

mkdir -p "$HOME/Downloads"
curl --url "$ZEPHYR_GH_URL" --output "$HOME/Downloads/$ZEPHYR_FILE" --location --fail

# Extract into $HOME (creates $HOME/zephyr-sdk-<version>)
tar -C "$HOME" -xf "$HOME/Downloads/$ZEPHYR_FILE"
"$ZEPHYR_INSTALL/setup.sh"
printf 'export ZEPHYR_SDK_INSTALL_DIR=%q\n' "$ZEPHYR_INSTALL" >> "$HOME/.bashrc"
export ZEPHYR_SDK_INSTALL_DIR="$ZEPHYR_INSTALL"

echo "Done. Open a new shell or run: source ~/.bashrc"
```


### 4. Setup Environment
```bash
mkdir -p ~/src
cd ~/src
git clone git@github.com:chgeuer/external_hitsmaxft_zmk-keyboard-cornix.git keyb_cornix

# 1) Create & activate venv, upgrade pip tooling, install west
cd ~/src/keyb_cornix
python -m venv zmk-env && source zmk-env/bin/activate
python -m pip install --upgrade pip wheel setuptools && pip install west

# 2) Initialize west workspace (uses your local manifest), fetch deps, export Zephyr
west init -l config/ && west update && west zephyr-export

# 3) Install Python deps (Zephyr script reqs + extras for ZMK Studio/nanopb)
pip install -r zephyr/scripts/requirements.txt pyelftools protobuf grpcio-tools
```

## Build

```bash
cd ~/src/keyb_cornix
source ~/src/keyb_cornix/zmk-env/bin/activate

west build -d build/left -s zmk/app -b cornix_left -- \
  -DBOARD_ROOT="${PWD}" \
  -DZMK_CONFIG="${PWD}/config" \
  -DSHIELD=cornix_indicator

west build -d build/right -s zmk/app -b cornix_right -- \
  -DBOARD_ROOT="${PWD}" \
  -DZMK_CONFIG="${PWD}/config" \
  -DSHIELD=cornix_indicator

mv build/left/zephyr/zmk.uf2 ./cornix_left.uf2
mv build/right/zephyr/zmk.uf2 ./cornix_right.uf2 
```

### Prompt

The `zsa_voyager_christian-geuer-pollmann-voyager_source` folder contains my very personal QMK keymap for a ZSA Voyager keyboard, which is a German Colemak-DHm configuration with homerow mods and a few macros for dead keys. 

The `config` folder contains a ZMK configuration for a wireless Cornix keyboard. 

Your task is to modify the Cornix configuration so that it re-created the ZSA Voyager behavior on the Cornix.

## Customizing Your Layout

### Main Keymap File
Edit: `config/cornix.keymap`

Key areas to modify:
- **Layer definitions**: 8 layers (Base, Windows, Symbols, Mix, Adjust, Navigation, NumPad, Debug)
- **Key bindings**: Change key mappings in the `bindings = <...>` sections
- **Combos**: Modify key combinations (ESC, TAB, ENTER combos)
- **Homerow mods**: Adjust timing in behavior definitions

### Example Layer Edit
```c
default_layer {
    display-name = "Base";
    bindings = <
        &kp TAB  &kp Q  &kp W  &kp E  &kp R  &kp T    &kp Y  &kp U  &kp I     &kp O   &kp P    &kp BSLH
        &kp ESC  &kp A  &kp S  &kp D  &kp F  &kp G    &kp H  &kp J  &kp K     &kp L   &kp SEMI &kp SQT
        // ... modify these key codes as needed
    >;
};
```

### Build Configuration
- `build.yaml`: Controls which board variants are built
- Uncomment `#shield: cornix_indicator` lines to enable RGB (uses more power)

## Flashing Firmware

### Standard Split Mode (No Dongle)
1. Flash `reset.uf2` to both halves first
2. Flash `cornix_left_default.uf2` to left half
3. Flash `cornix_right.uf2` to right half

### With Dongle Mode
1. Flash `reset.uf2` to keyboard halves
2. Flash `cornix_left_for_dongle.uf2` to left half
3. Flash `cornix_right.uf2` to right half
4. Flash `cornix_dongle.uf2` to separate dongle device

## Useful Tools

- **ZMK Keymap Editor**: https://nickcoutsos.github.io/keymap-editor/
- **ZMK Documentation**: https://zmk.dev/docs/
- **Key Codes Reference**: https://zmk.dev/docs/codes/

## Quick Commands Reference

### Maintenance Commands
```bash
# Update ZMK and dependencies
west update

# Check west configuration
west config

# Verify environment
which west
west --version
```

### Troubleshooting

**Build fails with "conflicting types for '__lock___libc_recursive_mutex'"**

- This indicates you have an incompatible SDK version (likely 0.17.x)
- **Solution**: Install the correct SDK 0.16.3 as shown in step 4 above
- Zephyr 3.5.0 (used in this repository) requires SDK 0.16.3, found in `/home/chgeuer/src/keyb_cornix/zephyr/.github/workflows/clang.yaml:23`

