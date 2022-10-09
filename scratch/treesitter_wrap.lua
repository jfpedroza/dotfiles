local ts_utils = require("nvim-treesitter.ts_utils")

local function wrap_cursor_node(winnr, before, after)
  local node = ts_utils.get_node_at_cursor(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)

  -- P(vim.treesitter.get_node_text(node, bufnr))

  local range = { node:range() }
  P(range)
  local lines = vim.api.nvim_buf_get_lines(bufnr, range[1], range[3] + 1, true)
  local last_line = lines[#lines]
  local with_after = last_line:gsub("()", { [range[4] + 1] = after })
  lines[#lines] = with_after

  local first_line = lines[1]
  local with_before = first_line:gsub("()", { [range[2] + 1] = before })
  lines[1] = with_before

  vim.api.nvim_buf_set_lines(bufnr, range[1], range[3] + 1, true, lines)

  return lines
end

P(wrap_cursor_node(0, "<<<<", ">>>>"))
