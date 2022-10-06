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

vim.keymap.set({ "n", "x", "o" }, "f", function()
  require("hop").hint_char1({ direction = after_cursor, current_line_only = true })
end)

vim.keymap.set({ "n", "x", "o" }, "F", function()
  require("hop").hint_char1({ direction = before_cursor, current_line_only = true })
end)

vim.keymap.set({ "n", "x", "o" }, "t", function()
  require("hop").hint_char1({ direction = after_cursor, current_line_only = true, hint_offset = -1 })
end)

vim.keymap.set({ "n", "x", "o" }, "T", function()
  require("hop").hint_char1({ direction = before_cursor, current_line_only = true, hint_offset = 1 })
end)

local function regex_hint(regex, opts)
  local global_opts = require("hop").opts
  local all_opts = setmetatable(opts or {}, { __index = global_opts })
  local jump_target = require("hop.jump_target")
  require("hop").hint_with(jump_target.jump_targets_by_scanning_lines(jump_target.regex_by_searching(regex)), all_opts)
end

vim.keymap.set("", "ẁ", function()
  require("hop").hint_words({ direction = after_cursor })
end)

vim.keymap.set("", "ė", function()
  regex_hint([[\k\+\zs\k]], { direction = after_cursor })
end)

vim.keymap.set("", "ḃ", function()
  require("hop").hint_words({ direction = before_cursor })
end)

vim.keymap.set("", "Ẁ", function()
  regex_hint([[\S\+]], { direction = after_cursor })
end)

vim.keymap.set("", "Ė", function()
  regex_hint([[\S\+\zs\S]], { direction = after_cursor })
end)

vim.keymap.set("", "Ḃ", function()
  regex_hint([[\S\+]], { direction = before_cursor })
end)

vim.keymap.set("", "ş", function()
  require("hop").hint_char1()
end)

-- vim.keymap.set("", "something here", function()
--   require("hop").hint_patterns()
-- end)
