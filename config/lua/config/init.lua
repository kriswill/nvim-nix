local opt = vim.opt

vim.g.mapleader = " "
vim.o.background = "dark"
-- vim.cmd.colorscheme "vague"
opt.list = true
opt.listchars = [[trail:·,tab:⇒\ ]]
vim.wo.relativenumber = true
vim.wo.number = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.mouse = "a"               --mouse support in all modes (why not?)
opt.clipboard = "unnamedplus" --allow nvim to inherit the system clipboard
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.hlsearch = false
opt.incsearch = true
opt.termguicolors = true
