return {
  "tpope/vim-fugitive",
  dependencies = { "tpope/vim-rhubarb" },
  keys = {
    { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
    { "<leader>gm", "<cmd>Git commit<cr>", desc = "Git commit" },
    { "<leader>ga", "<cmd>Git add %<cr>", desc = "Git add current file" },
    { "<leader>gA", "<cmd>Git add .<cr>", desc = "Git add all" },
    { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
    {
      "<leader>gu",
      function()
        local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
        vim.cmd("Git push --set-upstream origin " .. branch)
      end,
      desc = "Git push --set-upstream",
    },
    { "<leader>gP", "<cmd>Git pull<cr>", desc = "Git pull" },
    { "<leader>gl", "<cmd>Git log<cr>", desc = "Git log" },
    { "<leader>gd", "<cmd>Git diff<cr>", desc = "Git diff" },
    { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
    { "<leader>gR", "<cmd>Git revert<cr>", desc = "Git revert" },
    { "<leader>gB", "<cmd>GBrowse<cr>", desc = "Open in browser", mode = { "n", "v" } },
  },
}
