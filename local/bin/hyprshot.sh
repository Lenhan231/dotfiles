#!/usr/bin/env bash

set -euo pipefail

mode="${1:-both}" # save, copy, both
dir="${HOME}/Pictures/Screenshots"
mkdir -p "$dir"
file="${dir}/$(date +%Y-%m-%d_%H-%M-%S).png"

geometry="$(slurp)"
[[ -z "${geometry}" ]] && exit 0

capture() {
    grim -g "${geometry}" "$@"
}

case "${mode}" in
    copy)
        capture - | wl-copy --type image/png
        notify-send "Screenshot copied" "Use Ctrl+V to paste"
        ;;
    save)
        capture "${file}"
        notify-send "Screenshot saved" "${file}"
        ;;
    both)
        capture - | tee "${file}" | wl-copy --type image/png >/dev/null
        notify-send "Screenshot saved & copied" "${file}"
        ;;
    *)
        echo "Usage: $0 [save|copy|both]" >&2
        exit 1
        ;;
esac
