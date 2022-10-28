if not pcall(require, "overseer") then
  return
end

require("overseer").setup({
  task_list = {
    bindings = {
      ["<C-l>"] = false,
      ["<C-h>"] = false,
    },
  },
})

vim.keymap.set("n", "<F4>", function()
  require("overseer").toggle()
end)

vim.keymap.set("n", "<leader>o", function()
  vim.cmd.OverseerQuickAction("open float")
end)
