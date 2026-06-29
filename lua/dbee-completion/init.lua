local M = {}

local cache_path = vim.fn.stdpath("state") .. "/dbee/catalog_cache.json"
local temp_path = vim.fn.stdpath("state") .. "/dbee/query_result.json"
local pending_callbacks = {}

---@return { count: integer, data: table<string, table<string, string[]>> } | nil
function M.load_cache()
  local f = io.open(cache_path, "r")
  if not f then
    return nil
  end
  local content = f:read("*a")
  f:close()
  local ok, parsed = pcall(vim.fn.json_decode, content)
  if not ok then
    return nil
  end
  return parsed
end

---@param data table<string, table<string, string[]>>
---@param count integer
function M.save_cache(data, count)
  local dir = vim.fn.fnamemodify(cache_path, ":h")
  vim.fn.mkdir(dir, "p")
  local cache = { count = count, data = data }
  local json = vim.fn.json_encode(cache)
  local f = assert(io.open(cache_path, "w"))
  f:write(json)
  f:close()
end

local listener_registered = false

local function ensure_listener()
  if listener_registered then
    return
  end
  listener_registered = true

  require("dbee").api.core.register_event_listener("call_state_changed", function(data)
    local call_id = data.call.id
    local cb = pending_callbacks[call_id]
    if not cb then
      return
    end

    local state = data.call.state
    if state == "archive_failed" or state == "executing_failed" or state == "retrieving_failed" then
      pending_callbacks[call_id] = nil
      vim.notify("[dbee-completion] Query failed: " .. (data.call.error or "unknown"), vim.log.levels.ERROR)
      cb({})
      return
    end

    if state ~= "archived" then
      return
    end

    pending_callbacks[call_id] = nil

    require("dbee").api.core.call_store_result(call_id, "json", "file", { extra_arg = temp_path })

    vim.defer_fn(function()
      local f = io.open(temp_path, "r")
      if not f then
        cb({})
        return
      end
      local content = f:read("*a")
      f:close()
      local ok, rows = pcall(vim.fn.json_decode, content)
      if not ok then
        cb({})
        return
      end
      cb(rows)
    end, 200)
  end)
end

---@param query string
---@param callback fun(rows: table[])
function M.execute_and_read(query, callback)
  local api = require("dbee").api
  local conn = api.core.get_current_connection()
  if not conn then
    vim.notify("[dbee-completion] No active connection", vim.log.levels.WARN)
    callback({})
    return
  end

  ensure_listener()

  local call = api.core.connection_execute(conn.id, query)
  if not call or not call.id then
    vim.notify("[dbee-completion] Query execution failed", vim.log.levels.ERROR)
    callback({})
    return
  end

  pending_callbacks[call.id] = callback
end

function M.check_and_refresh()
  local cache = M.load_cache()

  M.execute_and_read("SELECT COUNT(*) as cnt FROM system.information_schema.tables", function(rows)
    if #rows == 0 then
      return
    end
    local count = tonumber(rows[1].cnt) or 0

    if cache and cache.count == count then
      return
    end
    M.full_refresh()
  end)
end

function M.full_refresh()
  local query = [[
    SELECT table_catalog, table_schema, table_name
    FROM system.information_schema.tables
    ORDER BY table_catalog, table_schema, table_name
  ]]

  M.execute_and_read(query, function(rows)
    local data = {}
    local count = #rows

    for _, row in ipairs(rows) do
      local catalog = row.table_catalog
      local schema = row.table_schema
      local tbl = row.table_name

      if catalog and schema and tbl then
        if not data[catalog] then
          data[catalog] = {}
        end
        if not data[catalog][schema] then
          data[catalog][schema] = {}
        end
        table.insert(data[catalog][schema], tbl)
      end
    end

    M.save_cache(data, count)
  end)
end

---@param prefix string
---@return { label: string, kind: integer }[]
function M.get_completions(prefix)
  local cache = M.load_cache()
  if not cache or not cache.data then
    return {}
  end

  local parts = vim.split(prefix, ".", { plain = true })
  local items = {}
  local CompletionItemKind = vim.lsp.protocol.CompletionItemKind

  if #parts <= 1 then
    for catalog, _ in pairs(cache.data) do
      table.insert(items, { label = catalog, kind = CompletionItemKind.Module })
    end
  elseif #parts == 2 then
    local catalog = parts[1]
    if cache.data[catalog] then
      for schema, _ in pairs(cache.data[catalog]) do
        table.insert(items, { label = schema, kind = CompletionItemKind.Class })
      end
    end
  elseif #parts == 3 then
    local catalog = parts[1]
    local schema = parts[2]
    if cache.data[catalog] and cache.data[catalog][schema] then
      for _, tbl in ipairs(cache.data[catalog][schema]) do
        table.insert(items, { label = tbl, kind = CompletionItemKind.Struct })
      end
    end
  end

  return items
end

vim.api.nvim_create_user_command("DbeeRefreshCache", function()
  M.full_refresh()
end, { desc = "Refresh dbee table completion cache" })

vim.api.nvim_create_user_command("DbeeCheckCache", function()
  M.check_and_refresh()
end, { desc = "Check and refresh dbee table completion cache if needed" })

return M