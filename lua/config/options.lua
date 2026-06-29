-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Choose where the root of the project is
vim.g.root_spec = { "lsp", { ".git", "lazyvim.json" }, "cwd" }

local databricks_pat_ = vim.env.DATABRICKS_TOKEN or ""
-- Format for Databricks JDBC/ODBC via Vim-Dadbod
vim.g.dbs = {
  databricks = {
    url = "jdbc:databricks://directsupply-databricks.cloud.databricks.com:443/default;transportMode=http;ssl=1;AuthMech=3;httpPath=/sql/1.0/warehouses/1a5189339b1ae039;PWD="
      .. databricks_pat_,
  },
}
vim.o.autoread = true
vim.o.updatetime = 250
