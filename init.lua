-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Blue window separators (must be after colorscheme loads)
vim.opt.fillchars:append({
  vert = "│",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*", -- Ensures it applies to all color schemes
  callback = function()
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#352796", bold = false })
  end,
})

vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#352796", bold = false })
