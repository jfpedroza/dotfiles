if not pcall(require, "nvim-tree") then
  return
end

require("nvim-tree").setup({})

local nt_api = require("nvim-tree.api")

vim.keymap.set("n", "<F5>", function()
  nt_api.tree.toggle({ find_file = true })
end, { desc = "Toggle file explorer" })
