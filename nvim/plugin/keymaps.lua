-- From tjdevries' markdown paste keymap
local function markdown_paste(link)
  link = link or vim.fn.getreg("+")
  local title = require("jp.tools").get_link_title(link)

  if title then
    vim.api.nvim_input(string.format("a[%s](%s)", title, link))
  end
end

vim.keymap.set("n", "<leader>mp", markdown_paste)
