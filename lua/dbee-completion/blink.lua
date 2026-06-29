local completion = require("dbee-completion")

---@class DbeeBlinkSource : blink.cmp.Source
local source = {}

function source.new(opts, config)
  local self = setmetatable({}, { __index = source })
  return self
end

function source:get_trigger_characters()
  return { "." }
end

function source:get_completions(context, callback)
  local line = context.line
  local col = context.cursor[2]
  local before_cursor = line:sub(1, col)

  local prefix = before_cursor:match("[%w_%.]+$") or ""

  if prefix == "" then
    callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = {} })
    return
  end

  local items = completion.get_completions(prefix)

  local result = {}
  for _, item in ipairs(items) do
    table.insert(result, {
      label = item.label,
      insertText = item.label,
    })
  end

  callback({
    is_incomplete_forward = false,
    is_incomplete_backward = false,
    items = result,
  })
end

return source