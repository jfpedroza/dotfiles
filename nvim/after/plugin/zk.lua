if not pcall(require, "zk") then
  return
end

local zk = require("zk")
local commands = require("zk.commands")
local tag_timer

zk.setup({
  picker = "telescope",
  lsp = {
    config = {
      on_attach = function()
        require("jp.zk").refresh_tags()
        if not tag_timer then
          tag_timer = vim.loop.new_timer()
          tag_timer:start(
            10000,
            10000,
            vim.schedule_wrap(function()
              require("jp.zk").refresh_tags()
            end)
          )
        end
      end,
    },
  },
})

commands.add("ZkJournal", function(options)
  options = vim.tbl_extend("force", { hrefs = { "journal/daily" }, sort = { "path-" } }, options or {})
  zk.edit(options, { title = "Journal Notes" })
end)

commands.add("ZkJournalNew", function(options)
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

vim.api.nvim_create_user_command("ZkAddNoteFromURL", function(opts)
  local link = opts.fargs[1]
  table.remove(opts.fargs, 1)
  local tags = opts.fargs
  require("jp.zk").new_from_url(link, tags)
end, {
  nargs = "+",
  complete = require("jp.zk").tag_complete,
})
