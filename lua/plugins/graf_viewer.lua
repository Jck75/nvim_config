--Note: this is spelled this way on purpose

return {
  {
    "nvim-lua/plenary.nvim", -- Required for the job/job control helpers
    lazy = true,
  },
  {
    "akinsho/toggleterm.nvim", -- Optional: if you prefer to use toggleterm
    version = "*",
    cmd = "ToggleTerm",
    keys = {
      {
        "<leader>tc",
        "<cmd>ToggleTerm cmd='YOUR_COMMAND_HERE' direction=vertical size=50<cr>",
        desc = "Run command in vertical term",
      },
    },
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
    -- Native implementation for opening side terminal and running graf
    keys = {
      { "<leader>ogg", function() require("graf_open")("current") end, desc = "Graf in current buffer" },
      { "<leader>ogh", function() require("graf_open")("left") end, desc = "Graf on left" },
      { "<leader>ogj", function() require("graf_open")("below") end, desc = "Graf below" },
      { "<leader>ogk", function() require("graf_open")("above") end, desc = "Graf above" },
      { "<leader>ogl", function() require("graf_open")("right") end, desc = "Graf on right" },
    },
  },
}
