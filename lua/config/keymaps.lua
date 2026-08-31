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

vim.keymap.set("n", "<leader>fa", function()
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

-- Run current AHK file
vim.keymap.set("n", "<leader>ckr", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  vim.fn.jobstart({ "autohotkey", file }, { detach = true })
  vim.notify("Running AHK: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
end, { desc = "Run AHK file" })

-- Create startup shortcut for current AHK file
vim.keymap.set("n", "<leader>cks", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  local name = vim.fn.expand("%:t:r")
  local startup_dir = vim.fn.expand("~/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup")
  local shortcut_path = startup_dir .. "/" .. name .. ".lnk"
  local ps_cmd = string.format(
    '$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut("%s"); $s.TargetPath = "%s"; $s.Save()',
    shortcut_path:gsub("/", "\\"),
    file:gsub("/", "\\")
  )
  vim.fn.jobstart({ "powershell", "-Command", ps_cmd }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.schedule(function()
          vim.notify("Startup shortcut created: " .. name .. ".lnk", vim.log.levels.INFO)
        end)
      else
        vim.schedule(function()
          vim.notify("Failed to create shortcut", vim.log.levels.ERROR)
        end)
      end
    end,
  })
end, { desc = "Add AHK to startup" })
