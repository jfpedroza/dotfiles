if not pcall(require, "telescope") then
  return
end

require("telescope").load_extension("fzf")

local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
    },
    mappings = {
      i = {
        ["<Esc>"] = actions.close,
      },
    },
  },
})

vim.cmd([[highlight TelescopeSelection guibg=#303030]])
vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal number]])

vim.keymap.set("n", "<leader>bb", require("telescope.builtin").buffers, { desc = "Show buffers on Telescope" })
vim.keymap.set("n", "<leader>f", require("telescope.builtin").find_files, { desc = "Find files using Telescope" })
