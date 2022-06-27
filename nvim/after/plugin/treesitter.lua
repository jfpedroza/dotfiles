if not pcall(require, "nvim-treesitter") then
  return
end

require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  ignore_install = { "haskell", "phpdoc" },
  highlight = { enable = true },
  indent = { enable = true },
})

vim.cmd([[set foldmethod=expr]])
vim.cmd([[set foldexpr=nvim_treesitterr#foldexpr()]])
