if PLUGIN_DISABLE.autoformat then
  return
end

vim.g.autoformat_autoindent = 0
vim.g.autoformat_retab = 0
vim.g.formatdef_ormolu = '"ormolu --stdin-input-file ."'
vim.g.formatters_haskell = { "ormolu" }

vim.keymap.set("", "<F3>", ":Autoformat<CR>")

local group = vim.api.nvim_create_augroup("Autoformat", { clear = true })
vim.api.nvim_create_autocmd("BufWrite", {
  group = group,
  pattern = "*",
  callback = function()
    if not vim.b.autoformat_disable and not vim.g.autoformat_disable then
      vim.cmd.Autoformat()
    end
  end,
})

vim.api.nvim_create_autocmd("BufRead", {
  group = group,
  pattern = "mix.lock",
  callback = function()
    vim.b.autoformat_disable = true
  end,
})

vim.api.nvim_create_user_command("AutoformatEnable", "let g:autoformat_disable = v:false", {})
vim.api.nvim_create_user_command("AutoformatEnableBuffer", "let b:autoformat_disable = v:false", {})
vim.api.nvim_create_user_command("AutoformatDisable", "let g:autoformat_disable = v:true", {})
vim.api.nvim_create_user_command("AutoformatDisableBuffer", "let b:autoformat_disable = v:true", {})
