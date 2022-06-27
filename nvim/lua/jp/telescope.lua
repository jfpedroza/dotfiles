if not pcall(require, "telescope") then
  return
end

require("telescope").load_extension("fzf")

vim.cmd([[highlight TelescopeSelection guibg=#303030]])
vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal number]])
