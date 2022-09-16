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
  right_sep = { " ", { str = "right_filled", hl = { bg = "violet", fg = "black" } } },
})

table.insert(components.active[1], {
  provider = "git_branch",
  hl = { bg = "violet", fg = "black", style = "bold" },
  left_sep = { { str = " ", hl = { bg = "violet", fg = "black" } } },
  right_sep = { { str = " ", hl = { bg = "violet" } }, { str = "right_filled", hl = { bg = "black", fg = "violet" } } },
})

---- Second section, active statusline
table.insert(components.active[1], {
  provider = { name = "file_info", opts = { type = "relative" } },
  hl = { bg = "black" },
  left_sep = { { str = " ", hl = { bg = "black", fg = "NONE" } } },
})

---- Third section, active statusline
table.insert(components.active[3], {
  provider = "line_percentage",
  hl = { bg = "oceanblue" },
  left_sep = {
    { str = "left_filled", hl = { bg = "black", fg = "oceanblue" } },
    { str = " ", hl = { bg = "oceanblue", fg = "NONE" } },
  },
})

table.insert(components.active[3], {
  provider = "position",
  hl = { bg = "oceanblue" },
  left_sep = { { str = " ", hl = { bg = "oceanblue", fg = "NONE" } } },
})

table.insert(components.active[3], {
  provider = "scroll_bar",
  hl = { bg = "oceanblue" },
  left_sep = { { str = " ", hl = { bg = "oceanblue", fg = "NONE" } } },
})

R("feline").setup({
  components = components,
  conditional_components = {},
})

-- R("feline").setup()
require("feline").winbar.setup()
