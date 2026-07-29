local function get_vault_folders()
  local vault_path = tostring(Obsidian.dir)
  local folders = { "." }
  local scan = require("plenary.scandir").scan_dir(vault_path, {
    only_dirs = true,
    hidden = false,
    depth = 5,
    add_dirs = true,
  })
  for _, dir in ipairs(scan) do
    local rel = dir:sub(#vault_path + 2):gsub("\\", "/")
    if not rel:match("^%.") then
      table.insert(folders, rel)
    end
  end
  return folders
end

local function new_note_with_folder_picker(title)
  local folders = get_vault_folders()
  vim.ui.select(folders, { prompt = "Choose folder for new note:" }, function(folder)
    if not folder then
      return
    end
    local function create(name)
      if not name or name == "" then
        return
      end
      local dir = folder == "." and "" or folder .. "/"
      vim.cmd("ObsidianNew " .. dir .. name)
    end
    if title then
      create(title)
    else
      vim.ui.input({ prompt = "Note title: " }, create)
    end
  end)
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/vaults/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/vaults/**.md",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>on",
      function()
        new_note_with_folder_picker()
      end,
      desc = "New note (choose folder)",
    },
    { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Open note" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
    { "<leader>od", "<cmd>edit " .. vim.fn.expand("~") .. "/vaults/work/hub_files/Central To-Do List.md<cr>", desc = "Central To-Do List" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Today's note" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
    { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Links in note" },
    { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename note" },
    { "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Switch workspace" },
    { "<leader>oi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image" },
    { "<leader>oc", "<cmd>ObsidianToggleCheckbox<cr>", desc = "Toggle checkbox" },
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    workspaces = {
      {
        name = "work",
        path = "C:\\Users\\jerecok\\vaults\\work",
      },
      {
        name = "todo",
        path = "C:\\Users\\jerecok\\vaults\\todo_list",
      },
    },
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      template = nil,
    },
    note_id_func = function(title)
      return title
    end,
    callbacks = {
      enter_note = function()
        vim.keymap.set("n", "gd", function()
          local api = require("obsidian").api
          local link = api.cursor_link()
          if not link then
            vim.lsp.buf.definition()
            return
          end

          local location = require("obsidian").util.parse_link(link)
          if not location then
            vim.lsp.buf.definition()
            return
          end

          location = vim.uri_decode(location)
          local search = require("obsidian").search
          search.resolve_note_async(location, function(notes)
            if not vim.tbl_isempty(notes) then
              require("obsidian").actions.follow_link(link)
            else
              new_note_with_folder_picker(location)
            end
          end)
        end, { buffer = true, desc = "Follow link or create note in folder" })
      end,
    },
  },
}
