-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.root_spec = { "lsp", { ".git", "lazyvim.json" }, "cwd" }

vim.o.autoread = true
vim.o.updatetime = 250
