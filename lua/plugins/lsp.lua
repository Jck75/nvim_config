return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Change to "basedpyright" if you use basedpyright instead of pyright
        pyright = {
          before_init = function(_, config)
            -- Check if a uv-style local virtual environment exists
            local venv_path = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.filereadable(venv_path) == 1 then
              config.settings.python.pythonPath = venv_path
            end
          end,
        },
      },
    },
  },
}
