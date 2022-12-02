if not pcall(require, "zk") then
  return
end

local zk = require("zk")
local commands = require("zk.commands")

zk.setup({
  picker = "telescope",
})

commands.add("ZkJournal", function(options)
  options = vim.tbl_extend("force", { dir = "journal/daily" }, options or {})
  zk.new(options)
end)

vim.keymap.set("n", "<leader>zn", function()
  zk.new({ title = vim.fn.input("Title: ") })
end)

vim.keymap.set("n", "<leader>zo", function()
  zk.edit({ sort = { "modified" } }, {})
end)

vim.keymap.set("n", "<leader>zt", function()
  vim.cmd.ZkTags()
end)

vim.keymap.set("n", "<leader>zf", function()
  zk.edit({ sort = { "modified" }, match = vim.fn.input("Search: ") }, {})
end)

vim.keymap.set("v", "<leader>zf", ":'<,'>ZkMatch<CR>")

local augroup = vim.api.nvim_create_augroup("zk-config", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup,
  pattern = vim.fn.expand("~") .. "/pwiki/*.md",
  callback = function()
    vim.bo.backupcopy = "yes"
  end,
})
