return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/vaults/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/vaults/**.md",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
    { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Open note" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
    { "<leader>od", "<cmd>ObsidianDailies<cr>", desc = "Daily notes" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Today's note" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
    { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Links in note" },
    { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename note" },
    { "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Switch workspace" },
    { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image" },
    { "<leader>oc", "<cmd>ObsidianToggleCheckbox<cr>", desc = "Toggle checkbox" },
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "C:\\Users\\jerecok\\vaults\\personal",
      },
      {
        name = "work",
        path = "C:\\Users\\jerecok\\vaults\\work",
      },
      {
        name = "school",
        path = "C:\\Users\\jerecok\\vaults\\school",
      },
    },
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      template = nil,
    },
    note_id_func = function(title)
      return title
    end,
  },
}
