# Quản lý dotfiles với symlink
---

### ⚙️ Workflow – Quản lý dotfiles bằng symlink

#### 🧩 Cấu trúc

```bash
~/dotfiles/
├── hypr/          -> ~/.config/hypr/
├── fcitx5/        -> ~/.config/fcitx5/
├── local-bin/     -> ~/.local/bin/
└── bashrc         -> ~/.bashrc
```

Mỗi thư mục trong `~/dotfiles` là **symlink** trỏ tới file thật trong hệ thống.

---

#### 💡 Cách làm việc hàng ngày

1. Sửa file thật như bình thường, ví dụ:

   ```bash
   nvim ~/.config/hypr/hyprland.conf
   ```
2. Quay lại repo để commit:

   ```bash
   cd ~/dotfiles
   git status      # thấy hypr/hyprland.conf đổi
   git add hypr/hyprland.conf
   git commit -m "update hyprland keybinds"
   git push
   ```

→ Git tự track nội dung vì symlink phản ánh thay đổi trực tiếp.

---

#### 🧰 Thêm thư mục mới vào dotfiles

Ví dụ anh muốn track `~/.config/waybar`:

```bash
mv ~/.config/waybar ~/dotfiles/waybar
ln -s ~/dotfiles/waybar ~/.config/waybar
git add waybar
git commit -m "add waybar config"
```

---

#### 🚀 Ưu điểm

* Làm việc tự nhiên trong `~/.config` (không sợ quên sync).
* Dễ backup và sync qua GitHub.
* Clone repo về máy mới rồi `stow` hoặc `ln -s` lại là full môi trường khôi phục.

---
