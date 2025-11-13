#!/usr/bin/env bash
set -euo pipefail

URL="https://discord.com/app"
EXTRA_ARGS=("$@")

launch_chromium_family() {
    local bin="$1"
    exec "$bin" \
        --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer \
        --ozone-platform=wayland \
        --enable-blink-features=WebRTCPipeWireCapturer \
        --app="$URL" "${EXTRA_ARGS[@]}"
}

launch_zen() {
    export MOZ_ENABLE_WAYLAND=1
    exec zen "$URL" "${EXTRA_ARGS[@]}"
}

if command -v chromium >/dev/null 2>&1; then
    launch_chromium_family chromium
elif command -v google-chrome-stable >/dev/null 2>&1; then
    launch_chromium_family google-chrome-stable
elif command -v google-chrome >/dev/null 2>&1; then
    launch_chromium_family google-chrome
elif command -v zen >/dev/null 2>&1; then
    launch_zen
else
    exec xdg-open "$URL"
fi
