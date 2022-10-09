vim.g.autoformat_autoindent = 0
vim.g.autoformat_retab = 0

vim.keymap.set("", "<F3>", ":Autoformat<CR>")

local group = vim.api.nvim_create_augroup("Autoformat", { clear = true })
vim.api.nvim_create_autocmd("BufWrite", {
  group = group,
  pattern = "*",
  command = "Autoformat",
})
