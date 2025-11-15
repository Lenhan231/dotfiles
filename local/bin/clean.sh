#!/bin/bash
set -euo pipefail

# Giữ lại bao nhiêu phiên bản gói đang cài (pacman cache)
KEEP_INSTALLED=${KEEP_INSTALLED:-1}   # 1 là gọn nhất
KEEP_UNINST=${KEEP_UNINST:-0}         # 0 = xóa hết cache gói đã gỡ
JOURNAL_KEEP=${JOURNAL_KEEP:-7d}      # log systemd giữ 7 ngày
CLEAN_USER_CACHE=${CLEAN_USER_CACHE:-1}    # 1 = dọn ~/.cache
CLEAN_THUMBS=${CLEAN_THUMBS:-1}            # 1 = dọn thumbnail

have(){ command -v "$1" >/dev/null 2>&1; }
say(){ echo -e "\n== $* =="; }

# 1) Dọn cache pacman
clean_pacman_cache(){
  say "Pacman cache"
  if have paccache; then
    sudo paccache -rk "$KEEP_INSTALLED" || true
    sudo paccache -ruk "$KEEP_UNINST" || true
  else
    # fallback (ít tinh vi hơn)
    sudo pacman -Sc --noconfirm || true
  fi
}

# 2) Dọn cache yay (nếu có)
clean_yay_cache(){
  if have yay; then
    say "Yay cache"
    yay -Sc --noconfirm || true
  fi
}

# 3) Hút log journal (giảm dung lượng /var/log/journal)
vacuum_journal(){
  say "Systemd journal"
  sudo journalctl --vacuum-time="$JOURNAL_KEEP" || true
}

# 4) Xoá orphan (giảm dung lượng thực vì gỡ pkg không còn dùng)
remove_orphans(){
  say "Remove orphan packages (an toàn)"
  ORPHANS=$(pacman -Qtdq || true)
  if [ -n "${ORPHANS:-}" ]; then
    echo "$ORPHANS" | xargs sudo pacman -Rns --noconfirm
  else
    echo "Không có orphan."
  fi
}

# 5) Dọn cache người dùng (~/.cache, thumbnails…)
clean_user_cache(){
  if [ "$CLEAN_USER_CACHE" = "1" ]; then
    say "User cache (~/.cache)"
    rm -rf "$HOME/.cache/"* 2>/dev/null || true
  fi
  if [ "$CLEAN_THUMBS" = "1" ]; then
    say "Thumbnails"
    rm -rf "$HOME/.cache/thumbnails/"* 2>/dev/null || true
  fi
}

# 6) Thư mục tạm
clean_tmp(){
  say "/tmp và ~/.cache/tmp (nếu có)"
  sudo rm -rf /tmp/* 2>/dev/null || true
  rm -rf "$HOME/.cache/tmp/"* 2>/dev/null || true
}

# 7) Báo dung lượng trước/sau
report_disk(){
  df -h /
}

main(){
  echo "Dung lượng trước:"
  report_disk
  clean_pacman_cache
  clean_yay_cache
  vacuum_journal
  remove_orphans
  clean_user_cache
  clean_tmp
  echo -e "\nDung lượng sau:"
  report_disk
  echo -e "\n✅ Xong."
}

main "$@"
