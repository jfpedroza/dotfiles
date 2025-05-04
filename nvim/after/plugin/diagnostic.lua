vim.diagnostic.config({
  underline = true,
  virtual_text = {
    source = "if_many",
    current_line = true,
  },
  -- virtual_lines = {
  --   source = "if_many",
  --   current_line = true,
  -- },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
  float = {
    source = "if_many",
  },
  severity_sort = true,
  update_in_insert = false,
})

-- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
--
-- for type, icon in pairs(signs) do
--   local hl = "DiagnosticSign" .. type
--   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
-- end

-- Go to the next diagnostic, but prefer going to errors first
local severity_levels = {
  vim.diagnostic.severity.ERROR,
  vim.diagnostic.severity.WARN,
  vim.diagnostic.severity.INFO,
  vim.diagnostic.severity.HINT,
}

local get_highest_error_severity = function()
  for _, level in ipairs(severity_levels) do
    local diags = vim.diagnostic.get(0, { severity = { min = level } })
    if #diags > 0 then
      return level, diags
    end
  end
end

vim.keymap.set("n", "[g", function()
  vim.diagnostic.jump({ count = -1 })
end)

vim.keymap.set("n", "[G", function()
  vim.diagnostic.jump({
    count = -1,
    severity = get_highest_error_severity(),
  })
end)

vim.keymap.set("n", "]g", function()
  vim.diagnostic.jump({ count = 1 })
end)

vim.keymap.set("n", "]G", function()
  vim.diagnostic.jump({
    count = 1,
    severity = get_highest_error_severity(),
  })
end)
