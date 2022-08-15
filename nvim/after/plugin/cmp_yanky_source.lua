local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end

source.complete = function(_, _, callback)
  local history = require("yanky.history").all()

  local items = {}
  for _, history_item in ipairs(history) do
    local item = {
      label = history_item.regcontents,
      documentation = history_item.regcontents,
    }

    table.insert(items, item)
  end

  callback({ items = items, isIncomplete = false })
end

require("cmp").register_source("yank_history", source.new())
