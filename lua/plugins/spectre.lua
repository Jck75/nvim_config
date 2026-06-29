return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>sr", function() require("spectre").open() end, desc = "Search & Replace" },
    { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Search word" },
    { "<leader>sp", function() require("spectre").open_file_search({ select_word = true }) end, desc = "Search in file" },
  },
  opts = {
    mapping = {
      ["toggle_line"] = {
        map = "dd",
        cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
        desc = "toggle current item",
      },
      ["enter_file"] = {
        map = "<cr>",
        cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
        desc = "open file",
      },
      ["send_to_qf"] = {
        map = "<leader>q",
        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
        desc = "send all items to quickfix",
      },
      ["replace_cmd"] = {
        map = "<leader>c",
        cmd = "<cmd>lua require('spectre').show_option_menu()<CR>",
        desc = "show options",
      },
      ["show_option_menu"] = {
        map = "<leader>o",
        cmd = "<cmd>lua require('spectre').show_option_menu()<CR>",
        desc = "show options",
      },
      ["run_current_replace"] = {
        map = "<leader>rc",
        cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
        desc = "replace current",
      },
      ["run_replace"] = {
        map = "<leader>Ra",
        cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
        desc = "replace all",
      },
      ["change_view_mode"] = {
        map = "<leader>v",
        cmd = "<cmd>lua require('spectre').change_view_mode()<CR>",
        desc = "results only / split view / preview only",
      },
    },
  },
}