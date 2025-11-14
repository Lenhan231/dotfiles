local map = vim.keymap.set

-- thoát insert nhanh
map("i", "jk", "<Esc>")

-- save / quit kiểu VSCode
map({ "n", "i" }, "<C-s>", "<Esc>:w<CR>", { silent = true })
map("n", "<C-q>", ":q<CR>", { silent = true })

-- xóa dòng nhanh
map("n", "<C-S-k>", "dd", { silent = true })

-- di chuyển giữa window
map("n", "<C-h>", "<C-w>h", { silent = true })
map("n", "<C-j>", "<C-w>j", { silent = true })
map("n", "<C-k>", "<C-w>k", { silent = true })
map("n", "<C-l>", "<C-w>l", { silent = true })

