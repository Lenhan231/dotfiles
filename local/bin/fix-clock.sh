#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '==> %s\n' "$*"
}

need_root() {
  cat <<'EOF' >&2
This script needs root privileges (either run as root or install sudo).
EOF
  exit 1
}

if [[ $EUID -ne 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO=(sudo)
  else
    need_root
  fi
else
  SUDO=()
fi

restart_ntp_service() {
  local svc
  for svc in systemd-timesyncd.service chronyd.service ntpd.service; do
    if systemctl list-unit-files "$svc" >/dev/null 2>&1; then
      log "Restarting $svc"
      "${SUDO[@]}" systemctl restart "$svc"
      return 0
    fi
  done
  log "No known NTP daemon unit found to restart (skipping)"
}

log "Current timedatectl status"
timedatectl status || true

log "Enabling systemd NTP sync"
"${SUDO[@]}" timedatectl set-ntp true

restart_ntp_service

log "Writing system clock to hardware clock"
"${SUDO[@]}" hwclock --systohc

log "Hardware clock after sync"
"${SUDO[@]}" hwclock --show

log "Final timedatectl status"
timedatectl status

log "Date (RFC-2822)"
date -R
