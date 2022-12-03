local M = {}

function M.new_note_selection()
  vim.ui.select({ "Title", "Content" }, { prompt = "Set selection as:" }, function(choice)
    if choice == "Title" then
      vim.cmd([['<,'>ZkNewFromTitleSelection]])
    elseif choice == "Content" then
      vim.cmd([['<,'>ZkNewFromContentSelection]])
    end
  end)
end

return M
