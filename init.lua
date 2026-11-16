-- 1. Set your leader key BEFORE loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Setting 1 turns off the default explore implementation from vim/nvim
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Show absolute number on the cursor line and relative distances elsewhere
vim.opt.number = true
vim.opt.relativenumber = true
-- A Tab character displays as 2 columns
vim.opt.tabstop = 2
-- Indent and outdent by 2 columns (for >> and auto-indent)
vim.opt.shiftwidth = 2
-- Insert spaces instead of Tab characters
vim.opt.expandtab = true
-- Basic automatic indentation for new lines (based on the previous line)
vim.opt.smartindent = true
-- Case-insensitive search...
vim.opt.ignorecase = true
-- ...unless the pattern contains an uppercase letter
vim.opt.smartcase = true
-- Use 24-bit colors in the terminal (needed by most modern colorschemes)
vim.opt.termguicolors = true
-- Always show the sign column (git and diagnostic markers) so text doesn't shift
vim.opt.signcolumn = "yes"
-- Don't wrap long lines onto the next screen line
vim.opt.wrap = false
-- Keep 8 lines visible above and below the cursor when scrolling
vim.opt.scrolloff = 8
-- Yank and paste use the system clipboard by default
vim.opt.clipboard = "unnamedplus"

-- 2. Define the installation path (~/.local/share/nvim/lazy/lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 3. Auto-clone lazy.nvim from GitHub if it is not present yet
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    return
  end
end

-- 4. Add lazy.nvim to Neovim's runtime path
vim.opt.rtp:prepend(lazypath)

-- 5. Initialize lazy.nvim from the ~/.config/nvim/lua/plugins/
require("lazy").setup("plugins")

-- Terminal mode: make Esc exit insert mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Resize windows with Ctrl+arrow keys
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { noremap = true })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { noremap = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true })
