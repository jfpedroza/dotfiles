vim.diagnostic.config({
  underline = true,
  virtual_text = {
    source = "if_many",
  },
  signs = true,
  float = {
    source = "if_many",
    format = function(d)
      local t = vim.deepcopy(d)
      local code = d.code or d.user_data.lsp.code

      if code then
        t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
      end

      return t.message
    end,
  },
  severity_sort = true,
  update_in_insert = false,
})

vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
