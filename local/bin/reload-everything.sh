#!/usr/bin/env bash
hyprctl reload
pkill waybar
waybar &
systemctl --user restart xdg-desktop-portal-hyprland.service
