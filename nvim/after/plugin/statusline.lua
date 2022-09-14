if not pcall(require, "feline") then
  return
end

vim.opt.laststatus = 3

local components = {
  active = {},
  inactive = {},
}

-- Insert three sections (left, mid and right) for the active statusline
table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.active, {})

-- Insert two sections (left and right) for the inactive statusline
table.insert(components.inactive, {})
table.insert(components.inactive, {})

---- First section, active statusline
-- Vi Mode
table.insert(components.active[1], {
  provider = {
    name = "vi_mode",
    opts = {
      show_mode_name = true,
    },
  },
  hl = function()
    return {
      name = require("feline.providers.vi_mode").get_mode_highlight_name(),
      fg = require("feline.providers.vi_mode").get_mode_color(),
      style = "bold",
    }
  end,
})

R("feline").setup({
  components = components,
  conditional_components = {},
})

-- R("feline").setup()
require("feline").winbar.setup()
