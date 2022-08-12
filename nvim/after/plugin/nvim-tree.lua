if not pcall(require, "nvim-tree") then
  return
end

require("nvim-tree").setup({})

local nt_api = require("nvim-tree.api")

vim.keymap.set("n", "<F5>", nt_api.tree.toggle, { desc = "Toggle file explorer" })
