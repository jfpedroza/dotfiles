vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

local colors = require("catppuccin.palettes").get_palette()

require("catppuccin").setup({
  custom_highlights = {
    ["@symbol"] = { fg = colors.red },
  },
})

vim.cmd.colorscheme("catppuccin")
