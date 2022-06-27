local M = {}

function M.makeScratch()
    vim.api.nvim_command('enew')
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'hide'
    vim.bo.swapfile = false
end

return M
