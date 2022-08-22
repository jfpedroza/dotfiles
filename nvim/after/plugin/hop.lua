if not pcall(require, "hop") then
  return
end

require("hop").setup({
  -- keys = "asdfghjklqwertyuiopzxcvbnm;",
})

local after_cursor = require("hop.hint").HintDirection.AFTER_CURSOR
local before_cursor = require("hop.hint").HintDirection.BEFORE_CURSOR

vim.keymap.set("", "ĵ", function()
  require("hop").hint_vertical({ direction = after_cursor })
end)

vim.keymap.set("", "ķ", function()
  require("hop").hint_vertical({ direction = before_cursor })
end)

vim.keymap.set("", "Ĵ", function()
  require("hop").hint_lines_skip_whitespace({ direction = after_cursor })
end)

vim.keymap.set("", "Ķ", function()
  require("hop").hint_lines_skip_whitespace({ direction = before_cursor })
end)

vim.keymap.set("", "ẁ", function()
  require("hop").hint_words({ direction = after_cursor })
end)

vim.keymap.set("", "ḟ", function()
  require("hop").hint_char1({ direction = after_cursor, current_line_only = true })
end)

vim.keymap.set("", "Ḟ", function()
  require("hop").hint_char1({ direction = before_cursor, current_line_only = true })
end)

vim.keymap.set("", "ť", function()
  require("hop").hint_char1({ direction = after_cursor, current_line_only = true, hint_offset = -1 })
end)

vim.keymap.set("", "Ť", function()
  require("hop").hint_char1({ direction = before_cursor, current_line_only = true, hint_offset = 1 })
end)

vim.keymap.set("", "ş", function()
  require("hop").hint_char1()
end)

-- vim.keymap.set("", "something here", function()
--   require("hop").hint_patterns()
-- end)
