return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle rendered markdown" },
    },
    opts = {},
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = "cd app && npm install",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Preview in browser (GitHub style)" },
      { "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", desc = "Stop browser preview" },
    },
    init = function()
      vim.g.mkdp_theme = "dark"
    end,
  },
}

