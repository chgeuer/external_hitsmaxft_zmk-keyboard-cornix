#!/bin/bash

source zmk-env/bin/activate

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

