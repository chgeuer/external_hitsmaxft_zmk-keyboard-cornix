# Cornix Keyboard Matrix Index Mapping

This document explains how the physical key positions on the Cornix split keyboard map to matrix indexes in the ZMK firmware.

![](https://metakeebs.com/cdn/shop/files/20250902162838_39d30b0a-bb0e-45fb-92fe-979cea521524.jpg?v=1756801828)

## Physical Layout Overview

The Cornix is a split keyboard with:
- **Left half**: 25 keys + 1 rotary encoder (with push button)
- **Right half**: 25 keys + 1 rotary encoder (with push button)
- **Total**: 50 keys + 2 encoder rotation + 2 encoder buttons = 54 matrix positions

**Key Discovery**: The left encoder push button is mapped to position 26 (`&kp X` in the matrix), not position 30 as initially assumed.

### Physical Key Layout (54-position matrix)

```
Left Half                                         Right Half
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┐   ┌─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│  0  │  1  │  2  │  3  │  4  │  5  │  ?  │   │  6  │  7  │  8  │  9  │ 10  │ 11  │ 12  │  Row 0 (14 pos)
├─────┼─────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│ 14  │ 15  │ 16  │ 17  │ 18  │ 19  │  ?  │   │ 20  │ 21  │ 22  │ 23  │ 24  │ 25  │ 26  │  Row 1 (14 pos)
├─────┼─────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│ 28  │ 29  │ 30  │ 31  │ 32  │ 33  │[ENC]│   │[ENC]│ 34  │ 35  │ 36  │ 37  │ 38  │ 39  │  Row 2 (16 pos)
├─────┼─────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│ 44  │ 45  │ 46  │ 47  │ 48  │ 49  │  ?  │   │ 50  │ 51  │ 52  │ 53  │ 54  │ 55  │ 56  │  Row 3 (14 pos)
└─────┴─────┴─────┴─────┴─────┴─────┴─────┘   └─────┴─────┴─────┴─────┴─────┴─────┴─────┘
                                    [Push]           [Push]
                               (Left Encoder)    (Right Encoder)
```

## Encoder Configuration

### Current Setup (As Requested)

- **Left encoder**:
  - **Rotation**: Volume up/down (but functions same as right for now)
  - **Push button**: Disabled (`&none` at position 30)
- **Right encoder**:
  - **Rotation**: Volume up/down
  - **Push button**: Mute (`&kp C_MUTE` at position 13)

### Position Mapping Discovery

Through testing, we discovered that:
- **Left encoder push button** is mapped to position 16 (2nd row, 3rd position) - where `X` would be
- **Right encoder push button** is mapped to position 27 (2nd row, last position)
- Both encoder rotations are handled by `sensor-bindings` configuration

### Special Positions
- **Position 16**: Left encoder push button (disabled with `&none`)
- **Position 27**: Right encoder push button (mute function `&kp C_MUTE`)
- **Encoder rotations**: Handled separately via `sensor-bindings`

## Matrix Transform Definition

From `cornix-layouts.dtsi`, the matrix is defined as:

```
columns = <14>;  // 7 columns per side
rows = <4>;      // 4 rows total
```

### Row-Column Mapping

The matrix uses this RC (Row-Column) mapping:

**Row 0 (Top row):**
```
RC(0,0) RC(0,1) RC(0,2) RC(0,3) RC(0,4) RC(0,5)     RC(0,12) RC(0,11) RC(0,10) RC(0,9) RC(0,8) RC(0,7)
  0       1       2       3       4       5           6        7        8        9      10      11
```

**Row 1 (Second row):**
```
RC(1,0) RC(1,1) RC(1,2) RC(1,3) RC(1,4) RC(1,5)     RC(1,12) RC(1,11) RC(1,10) RC(1,9) RC(1,8) RC(1,7)
  12      13      14      15      16      17          18       19       20       21     22      23
```

**Row 2 (Third row with encoders):**
```
RC(2,0) RC(2,1) RC(2,2) RC(2,3) RC(2,4) RC(2,5) RC(2,6) RC(1,13) RC(2,12) RC(2,11) RC(2,10) RC(2,9) RC(2,8) RC(2,7)
  24      25      26      27      28      29     30      31       32       33       34       35      36      37
                                              [Enc-L] [Enc-R]
```

**Row 3 (Bottom row):**
```
RC(3,0) RC(3,1) RC(3,2) RC(3,3) RC(3,4) RC(3,5)     RC(3,12) RC(3,11) RC(3,10) RC(3,9) RC(3,8) RC(3,7)
  38      39      40      41      42      43          44       45       46       47     48      49
```

## Key Assignment Issues Found

### Original Problem (Fixed)

The original keymap had a fundamental offset issue where:

1. **Wrong key count**: Only ~26 keys were defined per layer instead of 50
2. **Matrix mismatch**: The keymap didn't account for the encoder positions
3. **Key displacement**: Physical keys were mapped to wrong matrix positions

### Specific Issues Observed

From your testing, these specific mapping problems were identified:

**Row 1 Issues (positions 12-23):**
- Position 14: Should be `A`, was showing volume control
- Position 15: Should be `R`, was showing TAB
- Position 16: Should be `S`, was showing `A`
- Position 17: Should be `T`, was showing `R`
- Position 18: Should be `G`, was showing `S`
- Position 19: Should be `M`, was showing `T`
- Position 20: Should be `N`, was showing `G`
- Position 21: Should be `E`, was showing `M`
- Position 22: Should be `I`, was showing `N`
- Position 23: Should be `O`, was showing `E`
- Position 24: Should be `#`, was showing `I`

## Current Fixed Layout

### Layer 0 (Colemak-DHm Base Layer)

```
ESC     Q       W       F       P       B       -       -       J       L       U       Y       ß      MUTE
TAB     A       R       S       T       G       -       -       M       N       E       I       O       #     - -
CTRL    Z      none     C       D       V       -   -   -       K       H       ,       .       -     SHIFT - -
CTRL    ←       →      BSPC   SPC1   SnagIt    -       -      DEL    SPC2    ENT    Menu     ↑       ↓    - -
```

**Key Changes:**
- Position 30 (left encoder button): Disabled with `&none` instead of `X`
- Position 13 (right encoder button): Set to `&kp C_MUTE` for mute function
- Both encoders rotation: Volume up/down via `sensor-bindings`

### Keymap Array Structure

In ZMK, the keymap bindings array must contain exactly 56 positions (54 keys + 2 unused):

```c
bindings = <
    // Row 0 (14 positions: 0-13)
    &kp ESC    &kp Q    &kp W     &kp F     &kp P    &kp B       &none           &none           &kp J    &kp L    &kp U      &kp DE_Y  &kp DE_SS   &kp C_MUTE
    // Row 1 (14 positions: 14-27)
    &kp TAB    &kp A    &kp R     &kp S     &kp T    &kp G       &none           &none           &kp M    &kp N    &kp E      &kp I     &kp O       &kp DE_HASH     &none       &none
    // Row 2 (16 positions: 28-43)
    &kp LCTRL  &kp DE_Z &none     &kp C     &kp D    &kp V       &none   &none   &none           &kp K    &kp H    &kp COMMA  &kp DOT   &kp DE_MINS &kp RSHFT       &none       &none
    // Row 3 (14 positions: 44-57)
    &kp LCTRL  &kp LEFT &kp RIGHT &kp BSPC  &mo 1    &kp LC(LS(S)) &none         &none           &kp DEL  &mo 2    &kp RET    &kp K_CONTEXT_MENU &kp UP &kp DOWN &none &none
>;
```

## Encoder Configuration

The rotary encoders are configured separately in the `sensor-bindings`:

```c
sensor-bindings =
    <&inc_dec_kp C_VOLUME_UP C_VOLUME_DOWN>,    // Left encoder rotation
    <&inc_dec_kp C_VOLUME_UP C_VOLUME_DOWN>;    // Right encoder rotation
```

**Updated Configuration:**
- Both encoders control volume up/down on rotation
- Left encoder push button is disabled (`&none` at position 30)
- Right encoder push button triggers mute (`&kp C_MUTE` at position 13)

## Debugging Tips

When mapping keys to troubleshoot layout issues:

1. **Count positions sequentially**: Start from 0 (top-left) and count across each row
2. **Account for encoders**: Positions 30-31 are encoders, not regular keys
3. **Verify matrix size**: Total positions should equal exactly 50
4. **Test systematically**: Press each physical key and note its matrix position
5. **Check sensor bindings**: Encoders need separate configuration

## Build Notes

- The German character definitions are in `/config/includes/german.h`
- The matrix layout is defined in `/boards/arm/cornix/cornix-layouts.dtsi`
- Main keymap is in `/boards/arm/cornix/cornix.keymap`

This 50-key matrix layout ensures that each physical key on the Cornix keyboard maps correctly to its intended function in the keymap.