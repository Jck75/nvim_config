-- ~/.config/nvim/lua/plugins/dbee.lua
return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    require("dbee").install("go")
  end,
  config = function()
    require("dbee").setup({
      sources = {
        require("dbee.sources").FileSource:new(vim.fn.stdpath("config") .. "/lua/dbee-connections.json"),
        require("dbee.sources").FileSource:new(vim.fn.stdpath("state") .. "/dbee/persistence.json"),
      },
    })
  end,
}
