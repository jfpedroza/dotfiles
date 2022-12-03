local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

function M.make_scratch(filetype)
  vim.api.nvim_command("enew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false

  if filetype then
    vim.bo.filetype = filetype
  end
end

-- Ported from tjdevries' save_and_exec
function M.save_and_exec()
  if vim.bo.filetype == "vim" then
    vim.cmd([[
      silent! write
      source %
    ]])
    print("File " .. vim.fn.expand("%") .. " saved and executed")
  elseif vim.bo.filetype == "lua" then
    vim.cmd([[
      silent! write
      luafile %
    ]])
    print("File " .. vim.fn.expand("%") .. " saved and executed")
  else
    print("Not a vim or lua file")
  end
end

function M.wrap_range(bufnr, range, before, after)
  local lines = vim.api.nvim_buf_get_lines(bufnr, range[1], range[3] + 1, true)
  local last_line = lines[#lines]
  local with_after = last_line:gsub("()", { [range[4] + 1] = after })
  lines[#lines] = with_after

  local first_line = lines[1]
  local with_before = first_line:gsub("()", { [range[2] + 1] = before })
  lines[1] = with_before

  vim.api.nvim_buf_set_lines(bufnr, range[1], range[3] + 1, true, lines)
end

function M.wrap_cursor_node(before, after)
  local winnr = 0
  local node = ts_utils.get_node_at_cursor(winnr)

  if node then
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    local range = { node:range() }
    M.wrap_range(bufnr, range, before, after)
  else
    vim.notify("Wrap: Node not found", vim.log.levels.WARN)
  end
end

function M.wrap_selected_nodes(before, after)
  local start = vim.fn.getpos("'<")
  local end_ = vim.fn.getpos("'>")
  local bufnr = 0

  local start_node = vim.treesitter.get_node_at_pos(bufnr, start[2] - 1, start[3] - 1, {})
  local end_node = vim.treesitter.get_node_at_pos(bufnr, end_[2] - 1, end_[3] - 1, {})
  local start_range = { start_node:range() }
  local end_range = { end_node:range() }

  local range = { start_range[1], start_range[2], end_range[3], end_range[4] }

  M.wrap_range(bufnr, range, before, after)
end

function M.get_link_title(link)
  if not vim.startswith(link, "https://") then
    print("Input is not a link")
    return
  end

  local curl = require("plenary.curl")

  local request = curl.get(link)
  if request == nil then
    print("Request is nil")
    return
  end

  if not request.status == 200 then
    print("Failed to get link")
    return
  end

  local html_parser = vim.treesitter.get_string_parser(request.body, "html")
  if not html_parser then
    print("Must have html parser installed")
    return
  end

  local tree = (html_parser:parse() or {})[1]
  if not tree then
    print("Failed to parse tree")
    return
  end

  local query = vim.treesitter.parse_query(
    "html",
    [[
      (
       (element
        (start_tag
         (tag_name) @tag)
        (text) @text
       )
       (#eq? @tag "title")
      )
    ]]
  )

  for id, node in query:iter_captures(tree:root(), request.body, 0, -1) do
    local name = query.captures[id]
    if name == "text" then
      local title = vim.treesitter.get_node_text(node, request.body)
      return title
    end
  end

  print("Title not found")
end

return M
