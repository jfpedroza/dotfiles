local M = {}

function M.make_scratch()
  vim.api.nvim_command("enew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
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

return M
