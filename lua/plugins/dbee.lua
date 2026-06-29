return {
  {
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      require("dbee").install("go")
    end,
    cmd = {
      "Dbee",
    },
    keys = {
      { "<leader>db", "<cmd>Dbee open<cr>", desc = "Open DBEE" },
      { "<leader>dc", "<cmd>Dbee close<cr>", desc = "Close DBEE" },
    },
    config = function()
      local token = os.getenv("DATABRICKS_TOKEN_PROD_SQL") or ""
      require("dbee").setup({
        sources = {
          require("dbee.sources").MemorySource:new({
            {
              id = "databricks-prod",
              name = "Databricks Prod",
              type = "databricks",
              url = "token:"
                .. token
                .. "@directsupply-databricks.cloud.databricks.com:443/sql/1.0/warehouses/1a5189339b1ae039?catalog=hive_metastore",
            },
          }),
        },
      })

      local checked = false
      require("dbee").api.core.register_event_listener("current_connection_changed", function()
        if checked then
          return
        end
        checked = true
        vim.defer_fn(function()
          require("dbee-completion").check_and_refresh()
        end, 1000)
      end)
    end,
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "dbee" },
        providers = {
          dbee = {
            name = "dbee",
            module = "dbee-completion.blink",
            enabled = function()
              return vim.bo.filetype == "sql" or (vim.bo.buftype == "nofile" and vim.b.dbee_note ~= nil)
            end,
          },
        },
      },
    },
  },
}
