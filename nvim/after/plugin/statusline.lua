if not pcall(require, "feline") then
  return
end

if vim.g.started_by_firenvim then
  return
end

vim.o.laststatus = 3

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
      bg = require("feline.providers.vi_mode").get_mode_color(),
      fg = "black",
      style = "bold",
    }
  end,
  right_sep = {
    "block",
    {
      str = "right_filled",
      hl = function()
        local fg = require("feline.providers.vi_mode").get_mode_color()
        if require("feline.providers.git").git_info_exists() then
          return { bg = "violet", fg = fg }
        else
          return { bg = "black", fg = fg }
        end
      end,
    },
  },
})

table.insert(components.active[1], {
  provider = "git_branch",
  hl = { bg = "violet", fg = "black", style = "bold" },
  left_sep = { { str = "block" } },
  right_sep = { { str = " ", hl = { bg = "violet" } }, { str = "right_filled", hl = { bg = "black", fg = "violet" } } },
  icon = " ",
})

table.insert(components.active[1], {
  provider = "git_diff_added",
  hl = {
    fg = "green",
    bg = "black",
  },
})

table.insert(components.active[1], {
  provider = "git_diff_changed",
  hl = {
    fg = "orange",
    bg = "black",
  },
})

table.insert(components.active[1], {
  provider = "git_diff_removed",
  hl = {
    fg = "red",
    bg = "black",
  },
})

---- Second section, active statusline
table.insert(components.active[1], {
  provider = { name = "file_info", opts = { type = "relative" } },
  hl = { bg = "black" },
  left_sep = { { str = " ", hl = { bg = "black", fg = "NONE" } } },
})

---- Third section, active statusline
table.insert(components.active[3], {
  provider = function()
    return require("lsp-status").status_progress()
  end,
  right_sep = { " ", { str = "left", hl = { bg = "black", fg = "white" } } },
  truncate_hide = true,
})

table.insert(components.active[3], {
  provider = function()
    local fun, _ = string.gsub(vim.b.lsp_current_function or "", "%%", "%%%%")
    return fun
  end,
  left_sep = " ",
  right_sep = { " ", { str = "left", hl = { bg = "black", fg = "white" } } },
  enabled = function()
    return #vim.lsp.get_clients({ bufnr = 0 }) > 0
  end,
  truncate_hide = true,
})

table.insert(components.active[3], {
  provider = { name = "file_type", opts = { filetype_icon = true, case = "lowercase" } },
  left_sep = " ",
  right_sep = " ",
})

table.insert(components.active[3], {
  provider = "",
  hl = { bg = "black", fg = "white" },
  enabled = function()
    return require("feline.providers.lsp").diagnostics_exist()
  end,
})

table.insert(components.active[3], {
  provider = "diagnostic_errors",
  hl = { fg = "red" },
})

table.insert(components.active[3], {
  provider = "diagnostic_warnings",
  hl = { fg = "yellow" },
})

table.insert(components.active[3], {
  provider = "diagnostic_hints",
  hl = { fg = "cyan" },
})

table.insert(components.active[3], {
  provider = "diagnostic_info",
  hl = { fg = "skyblue" },
})

table.insert(components.active[3], {
  provider = " ",
  enabled = function()
    return require("feline.providers.lsp").diagnostics_exist()
  end,
})

table.insert(components.active[3], {
  provider = "file_encoding",
  hl = { bg = "yellow", fg = "black" },
  left_sep = {
    { str = "left_filled", hl = { bg = "black", fg = "yellow" } },
  },
})

table.insert(components.active[3], {
  provider = "file_format",
  hl = { bg = "yellow", fg = "black" },
  left_sep = { { str = "[", hl = { bg = "yellow", fg = "black" } } },
  right_sep = { { str = "]", hl = { bg = "yellow", fg = "black" } } },
})

table.insert(components.active[3], {
  provider = "line_percentage",
  hl = { bg = "oceanblue" },
  left_sep = {
    { str = "left_filled", hl = { bg = "yellow", fg = "oceanblue" } },
    { str = " ", hl = { bg = "oceanblue", fg = "NONE" } },
  },
})

table.insert(components.active[3], {
  provider = { name = "position", opts = { format = ":{line} ℅:{col}" } },
  hl = { bg = "oceanblue" },
  left_sep = { { str = " ", hl = { bg = "oceanblue", fg = "NONE" } } },
})

table.insert(components.active[3], {
  provider = "scroll_bar",
  hl = { bg = "oceanblue" },
  left_sep = { { str = " ", hl = { bg = "oceanblue", fg = "NONE" } } },
})

---- First section, inactive statusline
table.insert(components.inactive[1], {
  provider = { name = "file_type", opts = { case = "titlecase" } },
  hl = {
    fg = "white",
    bg = "green",
    style = "bold",
  },
  left_sep = {
    str = " ",
    hl = {
      fg = "NONE",
      bg = "green",
    },
  },
  right_sep = {
    {
      str = " ",
      hl = {
        fg = "NONE",
        bg = "green",
      },
    },
    "right_filled",
  },
})

-- Empty component to fix the highlight till the end of the statusline
table.insert(components.inactive[1], {})

-- Winbar
local winbar_components = {
  active = {},
  inactive = {},
}

-- One section for the winbar
table.insert(winbar_components.active, {})
table.insert(winbar_components.inactive, {})

table.insert(winbar_components.active[1], {
  provider = {
    name = "file_info",
    opts = {
      type = "unique",
    },
  },
  hl = {
    fg = "skyblue",
    bg = "NONE",
    style = "bold",
  },
})

table.insert(winbar_components.inactive[1], {
  provider = {
    name = "file_info",
    opts = {
      type = "unique",
    },
  },
  hl = {
    fg = "white",
    bg = "NONE",
    style = "bold",
  },
})

local force_inactive = {
  filetypes = {
    "^NvimTree$",
    "^packer$",
    "^startify$",
    "^fugitive$",
    "^fugitiveblame$",
    "^qf$",
    "^help$",
    "^neotest%-summary$",
    "^Mundo$",
    "^MundoDiff$",
    "^OverseerList$",
  },
  buftypes = {
    "^terminal$",
  },
  bufnames = {},
}

local winbar_disable = {
  filetypes = {},
  buftypes = {},
  bufnames = {},
}

require("feline").setup({
  components = components,
  conditional_components = {},
  force_inactive = force_inactive,
})

require("feline").winbar.setup({
  components = winbar_components,
  conditional_components = {},
  disable = winbar_disable,
})
