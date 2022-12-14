vim.o.foldcolumn = "1"

if not pcall(require, "ufo") or PLUGIN_DISABLE.ufo then
  vim.o.foldmethod = "indent"
  vim.o.foldlevelstart = 1
  vim.o.foldminlines = 2
  return
end

vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

require("ufo").setup()

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)

-- vim.wo.foldmethod = "expr"
-- vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.o.foldlevelstart = 1
-- vim.wo.foldminlines = 2
