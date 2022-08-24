if not pcall(require, "neotest") then
  return
end

require("neotest").setup({
  adapters = {
    require("neotest-vim-test")({ allow_file_types = { "elixir" } }),
  },
})
