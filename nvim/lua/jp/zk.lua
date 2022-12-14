local M = {
  tags = {},
}

local zk = require("zk")

function M.refresh_tags()
  require("zk.api").tag.list(nil, {}, function(err, tags)
    assert(not err, err)
    M.tags = vim.tbl_map(function(tag)
      return tag.name
    end, tags)
  end)
end

function M.tag_complete(arglead, _, _)
  return vim.tbl_filter(function(tag)
    return vim.startswith(tag, arglead)
  end, M.tags)
end

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
      content = string.format("<%s>", link),
      extra = {
        tags = table.concat(tags, ", "),
      },
      edit = true,
    })

    M.refresh_tags()
  end
end

return M
