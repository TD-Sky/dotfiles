#!/usr/bin/env bash

swayidle -w \
    timeout 300  'swaylock -f' \ # 5分钟锁屏
    timeout 600  'niri msg action power-off-monitors' \ # 10分钟熄屏
    resume       'niri msg action power-on-monitors' \
    timeout 1200 'systemctl suspend' # 20分钟挂起
