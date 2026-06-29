local function open_graf(position)
  local workspace = require("obsidian").get_client().current_workspace.name
  local vault_path = "C:\\Users\\jerecok\\vaults\\" .. workspace
  local pick_file = vim.fn.tempname()

  if position == "left" then
    vim.cmd("vsplit")
    vim.cmd("wincmd H")
  elseif position == "right" then
    vim.cmd("vsplit")
    vim.cmd("wincmd L")
  elseif position == "above" then
    vim.cmd("split")
    vim.cmd("wincmd K")
  elseif position == "below" then
    vim.cmd("split")
    vim.cmd("wincmd J")
  end

  vim.cmd("enew")

  local buf = vim.api.nvim_get_current_buf()

  vim.fn.jobstart({ "graf", "--dir", vault_path, "--pick", pick_file }, {
    term = true,
    on_exit = function()
      vim.schedule(function()
        vim.api.nvim_buf_delete(buf, { force = true })

        local f = io.open(pick_file, "r")
        if f then
          local file = f:read("*a")
          f:close()
          os.remove(pick_file)
          if file and file ~= "" then
            vim.cmd("edit " .. vim.fn.fnameescape(file))
          end
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = buf,
    callback = function()
      vim.o.mouse = "a"
      vim.cmd("startinsert")
    end,
  })
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    callback = function()
      vim.o.mouse = ""
    end,
  })

  vim.o.mouse = "a"
  vim.cmd("startinsert")
end

return open_graf

