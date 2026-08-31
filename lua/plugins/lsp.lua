return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          before_init = function(_, config)
            local root = config.root_dir or vim.fn.getcwd()
            local venv_path = root .. "/.venv/Scripts/python.exe"
            if vim.fn.filereadable(venv_path) == 1 then
              config.settings = config.settings or {}
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = venv_path
            end
          end,
          settings = {
            python = {
              analysis = {
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
              },
            },
          },
        },
      },
    },
  },
}
