#!/bin/bash
# Update script cho Arch Linux (pacman + yay)

echo "🔄 Updating system packages..."
sudo pacman -Syyu --noconfirm

echo "✨ Updating AUR packages (yay)..."
if command -v yay >/dev/null 2>&1; then
    yay -Syu --noconfirm
else
    echo "⚠️ Yay chưa được cài đặt — bỏ qua phần AUR."
fi

echo "🧹 Cleaning cache..."
sudo pacman -Sc --noconfirm
yay -Sc --noconfirm 2>/dev/null

echo "✅ Update hoàn tất!"
