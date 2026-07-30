if not pcall(require, "lualine") then
  return
end

if vim.g.started_by_firenvim then
  return
end

local has_lsp_status, lsp_status = pcall(require, "lsp-status")

local colors = {
  bg = "#1F1F23",
  fg = "#D0D0D0",
  black = "#1B1B1B",
  skyblue = "#50B0F0",
  cyan = "#009090",
  green = "#60A040",
  oceanblue = "#0066cc",
  orange = "#FF9000",
  red = "#D10000",
  violet = "#9E93E8",
  white = "#FFFFFF",
  yellow = "#E1E120",
}

local separators = {
  thin = "",
  left_filled = "",
  right_filled = "",
}

local mode_names = {
  ["n"] = "NORMAL",
  ["no"] = "OP",
  ["nov"] = "OP",
  ["noV"] = "OP",
  ["no\22"] = "OP",
  ["niI"] = "NORMAL",
  ["niR"] = "NORMAL",
  ["niV"] = "NORMAL",
  ["v"] = "VISUAL",
  ["vs"] = "VISUAL",
  ["V"] = "LINES",
  ["Vs"] = "LINES",
  ["\22"] = "BLOCK",
  ["\22s"] = "BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT",
  ["\19"] = "BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["ix"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rc"] = "REPLACE",
  ["Rv"] = "V-REPLACE",
  ["Rx"] = "REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "COMMAND",
  ["ce"] = "COMMAND",
  ["r"] = "ENTER",
  ["rm"] = "MORE",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERM",
  ["nt"] = "TERM",
}

local mode_colors = {
  ["NORMAL"] = colors.green,
  ["OP"] = colors.green,
  ["INSERT"] = colors.red,
  ["VISUAL"] = colors.skyblue,
  ["LINES"] = colors.skyblue,
  ["BLOCK"] = colors.skyblue,
  ["REPLACE"] = colors.violet,
  ["V-REPLACE"] = colors.violet,
  ["ENTER"] = colors.cyan,
  ["MORE"] = colors.cyan,
  ["SELECT"] = colors.orange,
  ["COMMAND"] = colors.green,
  ["SHELL"] = colors.green,
  ["TERM"] = colors.green,
  ["NONE"] = colors.yellow,
}

local function current_mode()
  return mode_names[vim.api.nvim_get_mode().mode] or "NONE"
end

-- The thin separators are drawn on their own background, so they need a
-- highlight group of their own. `:colorscheme` clears it, hence the autocmd.
local separator_hl = "JpStatuslineSeparator"
local thin_separator = "%#" .. separator_hl .. "#" .. separators.thin

local function set_separator_hl()
  vim.api.nvim_set_hl(0, separator_hl, { fg = colors.white, bg = colors.black })
end

set_separator_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("JpStatusline", { clear = true }),
  callback = set_separator_hl,
})

local function diagnostics_exist()
  return #vim.diagnostic.get(0) > 0
end

-- The wordy LSP components are only shown when there's room for them
local function has_room()
  return vim.o.columns > 120
end

-- Shortest path suffix that tells this buffer apart from the other listed ones
local function unique_filename()
  local filename = vim.api.nvim_buf_get_name(0)
  if filename == "" then
    return "[No Name]"
  end

  local current = vim.api.nvim_get_current_buf()
  local others = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= current and vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_loaded(bufnr) then
      table.insert(others, vim.api.nvim_buf_get_name(bufnr))
    end
  end

  local segments = vim.split(filename, "/", { plain = true })
  local name = segments[#segments]
  for i = #segments - 1, 1, -1 do
    local ambiguous = false
    for _, other in ipairs(others) do
      if other == name or vim.endswith(other, "/" .. name) then
        ambiguous = true
        break
      end
    end

    if not ambiguous then
      break
    end

    name = table.concat(segments, "/", i, #segments)
  end

  return (name:gsub("%%", "%%%%"))
end

local scroll_bar_blocks = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }

local mode = {
  current_mode,
  padding = 1,
  color = function()
    return { fg = colors.black, bg = mode_colors[current_mode()] or colors.yellow, gui = "bold" }
  end,
  separator = { right = separators.right_filled },
}

local branch = {
  "branch",
  icon = "",
  padding = 1,
  color = { fg = colors.black, bg = colors.violet, gui = "bold" },
  separator = { right = separators.right_filled },
}

local diff = {
  "diff",
  source = function()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
    end
  end,
  symbols = { added = " ", modified = "柳", removed = " " },
  diff_color = {
    added = { fg = colors.green, bg = colors.black },
    modified = { fg = colors.orange, bg = colors.black },
    removed = { fg = colors.red, bg = colors.black },
  },
  color = { bg = colors.black },
  padding = { left = 1, right = 0 },
}

local file_icon = {
  "filetype",
  icon_only = true,
  colored = true,
  -- The component is skipped when the filetype is empty, so give it something to
  -- render and let the default icon show up
  fmt = function(str)
    return str == "" and " " or str
  end,
  padding = { left = 1, right = 0 },
  color = { bg = colors.black },
}

local filename = {
  "filename",
  path = 1,
  shorting_target = 0,
  symbols = { modified = "●", readonly = "🔒", unnamed = "[No Name]" },
  padding = 0,
  color = { bg = colors.black },
}

local lsp_progress = {
  function()
    local progress = lsp_status.status_progress()
    if progress == "" then
      return ""
    end

    return progress .. " " .. thin_separator
  end,
  cond = function()
    return has_lsp_status and has_room()
  end,
  padding = 0,
}

local lsp_current_function = {
  function()
    local fun = (vim.b.lsp_current_function or ""):gsub("%%", "%%%%")
    if fun == "" then
      return ""
    end

    return " " .. fun .. " " .. thin_separator
  end,
  cond = function()
    return has_room() and #vim.lsp.get_clients({ bufnr = 0 }) > 0
  end,
  padding = 0,
}

local filetype = {
  "filetype",
  colored = true,
  padding = 1,
}

local diagnostics_separator = {
  function()
    return thin_separator
  end,
  cond = diagnostics_exist,
  padding = 0,
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn", "hint", "info" },
  symbols = { error = " ", warn = " ", hint = " ", info = " " },
  diagnostics_color = {
    error = { fg = colors.red },
    warn = { fg = colors.yellow },
    hint = { fg = colors.cyan },
    info = { fg = colors.skyblue },
  },
  padding = 1,
}

local encoding = {
  function()
    return ((vim.bo.fileencoding ~= "" and vim.bo.fileencoding) or vim.o.encoding):upper()
  end,
  color = { fg = colors.black, bg = colors.yellow },
  separator = { left = separators.left_filled },
  padding = 0,
}

local fileformat = {
  function()
    return "[" .. ((vim.bo.fileformat ~= "" and vim.bo.fileformat) or vim.o.fileformat):upper() .. "]"
  end,
  color = { fg = colors.black, bg = colors.yellow },
  padding = 0,
}

local line_percentage = {
  "progress",
  color = { bg = colors.oceanblue },
  separator = { left = separators.left_filled },
  padding = { left = 1, right = 0 },
}

local position = {
  function()
    return string.format(":%d/%d ℅:%d", vim.fn.line("."), vim.fn.line("$"), vim.fn.virtcol("."))
  end,
  color = { bg = colors.oceanblue },
  padding = { left = 1, right = 0 },
}

local scroll_bar = {
  function()
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    return string.rep(scroll_bar_blocks[math.floor(curr_line / lines * 7) + 1], 2)
  end,
  color = { bg = colors.oceanblue },
  padding = { left = 1, right = 0 },
}

local winbar_filename = {
  unique_filename,
  color = { fg = colors.skyblue, bg = "NONE", gui = "bold" },
}

local inactive_winbar_filename = vim.tbl_deep_extend("force", winbar_filename, {
  color = { fg = colors.white },
})

-- Statusline shown instead of the regular one on the filetypes listed in the
-- extension below
local minimal_sections = {
  lualine_a = {
    {
      "filetype",
      icons_enabled = false,
      fmt = function(str)
        return (str:gsub("^%l", string.upper))
      end,
      color = { fg = colors.white, bg = colors.green, gui = "bold" },
      separator = { right = separators.right_filled },
    },
  },
  lualine_b = {},
  lualine_c = {},
  lualine_x = {},
  lualine_y = {},
  lualine_z = {},
}

local base_hl = { fg = colors.fg, bg = colors.bg }
local theme = {
  normal = {
    a = base_hl,
    b = base_hl,
    c = base_hl,
    x = base_hl,
    y = base_hl,
    z = base_hl,
  },
}
theme.inactive = theme.normal

require("lualine").setup({
  options = {
    theme = theme,
    globalstatus = true,
    component_separators = "",
    section_separators = "",
  },
  sections = {
    lualine_a = { mode },
    lualine_b = { branch, diff },
    lualine_c = { file_icon, filename },
    lualine_x = { lsp_progress, lsp_current_function, filetype, diagnostics_separator, diagnostics },
    lualine_y = { encoding, fileformat },
    lualine_z = { line_percentage, position, scroll_bar },
  },
  inactive_sections = minimal_sections,
  winbar = {
    lualine_c = { winbar_filename },
  },
  inactive_winbar = {
    lualine_c = { inactive_winbar_filename },
  },
  extensions = {
    {
      sections = minimal_sections,
      inactive_sections = minimal_sections,
      filetypes = {
        "NvimTree",
        "lazy",
        "startify",
        "fugitive",
        "fugitiveblame",
        "qf",
        "help",
        "neotest-summary",
        "Mundo",
        "MundoDiff",
        "OverseerList",
        "floaterm",
      },
    },
  },
})
