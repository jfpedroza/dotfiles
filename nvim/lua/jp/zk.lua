local M = {}

local zk = require("zk")

function M.new_note_selection()
  vim.ui.select({ "Title", "Content" }, { prompt = "Set selection as:" }, function(choice)
    if choice == "Title" then
      vim.cmd([['<,'>ZkNewFromTitleSelection]])
    elseif choice == "Content" then
      vim.cmd([['<,'>ZkNewFromContentSelection]])
    end
  end)
end

function M.new_from_url(link, tags)
  local title = require("jp.tools").get_link_title(link)
  if title then
    zk.new({
      title = title,
      content = string.format("[%s](%s)", link, link),
      extra = {
        tags = table.concat(tags, ", "),
      },
      edit = true,
    })
  end
end

return M
