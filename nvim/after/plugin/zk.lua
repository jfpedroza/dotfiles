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

-- Create a new note after asking for its title.
vim.keymap.set("n", "<leader>zn", function()
  vim.ui.input({ prompt = "Title: " }, function(title)
    if title then
      zk.new({ title = title })
    end
  end)
end)

-- Open notes.
vim.keymap.set("n", "<leader>zo", function()
  zk.edit({ sort = { "modified" } }, {})
end)

-- Open notes associated with the selected tags.
vim.keymap.set("n", "<leader>zt", function()
  vim.cmd.ZkTags()
end)

-- Search for the notes matching a given query.
vim.keymap.set("n", "<leader>zf", function()
  vim.ui.input({ prompt = "Search: " }, function(match)
    if match then
      zk.edit({ sort = { "modified" }, match = match }, {})
    end
  end)
end)

-- Search for the notes matching the current visual selection.
vim.keymap.set("v", "<leader>zf", ":ZkMatch<CR>")

local augroup = vim.api.nvim_create_augroup("zk-config", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup,
  pattern = vim.fn.expand("~") .. "/pwiki/*.md",
  callback = function()
    vim.bo.backupcopy = "yes"
  end,
})

function _G.zk_new_note_selection()
  vim.ui.select({ "Title", "Content" }, { prompt = "Set selection as:" }, function(choice)
    if choice == "Title" then
      vim.cmd([['<,'>ZkNewFromTitleSelection]])
    elseif choice == "Content" then
      vim.cmd([['<,'>ZkNewFromContentSelection]])
    end
  end)
end
