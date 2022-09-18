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
      local code = d.code or vim.tbl_get(d, "user_data", "lsp", "code")

      if code then
        t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
      end

      return t.message
    end,
  },
  severity_sort = true,
  update_in_insert = false,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
