return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Change to "basedpyright" if you use basedpyright instead of pyright
        pyright = {
          before_init = function(_, config)
            -- Check if a uv-style local virtual environment exists
            local venv_path = vim.fn.getcwd() .. "/.venv/Scripts/python.exe"
            if vim.fn.filereadable(venv_path) == 1 then
              config.settings.python.pythonPath = venv_path
            end
          end,
          settings = {
            python = {
              analysis = {
                -- Scans all files in your workspace, not just open buffers
                diagnosticMode = "workspace",
                typeCheckingMode = "basic", -- or "strict", "off"
              },
            },
          },
        },
      },
    },
  },
}
