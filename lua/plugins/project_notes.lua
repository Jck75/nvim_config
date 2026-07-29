local vault_path = vim.fn.expand("~") .. "/vaults/work"
local notes_file = ".project-notes"

local function get_project_notes_path()
  local root = vim.fn.getcwd()
  return root .. "/" .. notes_file
end

local function read_project_notes()
  local path = get_project_notes_path()
  local f = io.open(path, "r")
  if not f then
    return {}
  end
  local lines = {}
  for line in f:lines() do
    local trimmed = vim.trim(line)
    if trimmed ~= "" then
      table.insert(lines, trimmed)
    end
  end
  f:close()
  return lines
end

local function write_project_notes(lines)
  local path = get_project_notes_path()
  local f = io.open(path, "w")
  if not f then
    vim.notify("Cannot write " .. path, vim.log.levels.ERROR)
    return
  end
  for _, line in ipairs(lines) do
    f:write(line .. "\n")
  end
  f:close()
end

local function collect_vault_notes(dir, prefix)
  local notes = {}
  local handle = vim.loop.fs_scandir(dir)
  if not handle then
    return notes
  end
  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end
    local rel = prefix == "" and name or (prefix .. "/" .. name)
    if type == "directory" and name ~= ".obsidian" and name ~= ".trash" then
      local sub = collect_vault_notes(dir .. "/" .. name, rel)
      for _, n in ipairs(sub) do
        table.insert(notes, n)
      end
    elseif type == "file" and name:match("%.md$") then
      table.insert(notes, rel)
    end
  end
  return notes
end

local function mark_note()
  local existing = read_project_notes()
  local existing_set = {}
  for _, e in ipairs(existing) do
    existing_set[e] = true
  end

  local all_notes = collect_vault_notes(vault_path, "")
  local available = vim.tbl_filter(function(n)
    return not existing_set[n]
  end, all_notes)

  if #available == 0 then
    vim.notify("All vault notes are already linked", vim.log.levels.INFO)
    return
  end

  vim.ui.select(available, { prompt = "Select note to link to project:" }, function(choice)
    if not choice then
      return
    end
    table.insert(existing, choice)
    write_project_notes(existing)

    local note_path = vault_path .. "/" .. choice
    local project_dir = vim.fn.getcwd()
    local f = io.open(note_path, "r")
    if f then
      local content = f:read("*a")
      f:close()
      local front_end = content:find("\n---", 2, true)
      if front_end then
        local line_end = content:find("\n", front_end + 4, true) or (#content + 1)
        content = content:sub(1, line_end) .. project_dir .. "\n" .. content:sub(line_end + 1)
      else
        content = project_dir .. "\n" .. content
      end
      f = io.open(note_path, "w")
      if f then
        f:write(content)
        f:close()
      end
    end

    vim.notify("Linked: " .. choice, vim.log.levels.INFO)
  end)
end

local function extract_project_dirs(note_path)
  local f = io.open(note_path, "r")
  if not f then
    return {}
  end
  local dirs = {}
  local in_frontmatter = false
  for line in f:lines() do
    local trimmed = vim.trim(line)
    if trimmed == "---" then
      if not in_frontmatter then
        in_frontmatter = true
      else
        in_frontmatter = false
      end
    elseif not in_frontmatter and trimmed:match("^%a:[\\/]") then
      table.insert(dirs, trimmed)
    end
  end
  f:close()
  return dirs
end

local function is_in_vault()
  local buf_path = vim.fn.expand("%:p"):gsub("\\", "/"):lower()
  local normalized_vault = vault_path:gsub("\\", "/"):lower()
  return buf_path:sub(1, #normalized_vault) == normalized_vault
end

local function cd_to_dir(dir)
  if vim.fn.isdirectory(dir) == 0 then
    vim.notify("Project directory does not exist: " .. dir, vim.log.levels.ERROR)
    return
  end
  vim.cmd("cd " .. vim.fn.fnameescape(dir))
  vim.notify("Changed to: " .. dir, vim.log.levels.INFO)
end

local function open_project_notes()
  if is_in_vault() then
    local buf_path = vim.fn.expand("%:p")
    local dirs = extract_project_dirs(buf_path)
    if #dirs == 0 then
      vim.notify("No project directory found in this note.", vim.log.levels.WARN)
      return
    end
    if #dirs == 1 then
      cd_to_dir(dirs[1])
      return
    end
    vim.ui.select(dirs, { prompt = "Select project directory:" }, function(choice)
      if choice then
        cd_to_dir(choice)
      end
    end)
    return
  end

  local notes = read_project_notes()
  if #notes == 0 then
    vim.notify("No project notes linked. Use <leader>om to add one.", vim.log.levels.WARN)
    return
  end

  if #notes == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(vault_path .. "/" .. notes[1]))
    return
  end

  vim.ui.select(notes, { prompt = "Open project note:" }, function(choice)
    if not choice then
      return
    end
    vim.cmd("edit " .. vim.fn.fnameescape(vault_path .. "/" .. choice))
  end)
end

return {
  dir = vim.fn.stdpath("config") .. "/lua/plugins",
  name = "project-notes",
  lazy = false,
  keys = {
    { "<leader>om", mark_note, desc = "Link vault note to project" },
    { "<leader>op", open_project_notes, desc = "Open project notes" },
  },
}