-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Move directly out of the terminal window to another split
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to Left Window" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to Bottom Window" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to Top Window" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to Right Window" })

-- Enter normal mode without sending escape to the running process
vim.keymap.set("t", "<C-]>", "<C-\\><C-n>", { desc = "Enter normal mode" })

local home_dir = vim.fn.expand("~")
local function is_in_home()
  return vim.fn.getcwd() == home_dir
end

vim.keymap.set("n", "<leader>fc", function()
  local config_dir = vim.fn.stdpath("config")
  if is_in_home() then
    vim.cmd("lcd " .. vim.fn.fnameescape(config_dir))
  end
  LazyVim.pick("files", { cwd = config_dir })()
end, { desc = "Find Config File" })

vim.keymap.set("n", "<leader>as", function()
  local claude_dir = home_dir .. "/.claude"
  if is_in_home() then
    vim.cmd("lcd " .. vim.fn.fnameescape(claude_dir))
  end
  LazyVim.pick("files", { cwd = claude_dir })()
end, { desc = "Find Claude Settings" })

-- Jump to previous URL in terminal buffer
vim.keymap.set("t", "<C-b>", function()
  local url_pattern = "https?://[%w%-._~:/?#%[%]@!$&'()*+,;=%%]+"
  vim.cmd("normal! \28\14") -- <C-\><C-n> to enter normal mode
  local found = vim.fn.search(url_pattern, "bW")
  if found == 0 then
    vim.notify("No previous URL found", vim.log.levels.INFO)
  end
end, { desc = "Go to previous URL" })

-- Run current file with uv
vim.keymap.set("n", "<leader>cr", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  Snacks.terminal("uv run " .. vim.fn.shellescape(file))
end, { desc = "Run file with uv" })
