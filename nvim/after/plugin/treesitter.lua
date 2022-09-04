if not pcall(require, "nvim-treesitter") then
  return
end

require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  ignore_install = { "haskell", "phpdoc" },
  highlight = { enable = true },
  indent = { enable = true },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "<leader>re",
      },
    },
    navigation = {
      enable = false,
      keymaps = {
        goto_definition = nil,
        goto_definition_lsp_fallback = nil,
        list_definitions = nil,
        list_definitions_toc = nil,
        goto_next_usage = nil,
        goto_previous_usage = nil,
      },
    },
  },
  playground = {
    enable = true,
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
})

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevelstart = 1
vim.wo.foldminlines = 2
