local linters = {}

linters.shellcheck = {
  command = "shellcheck",
  debounce = 100,
  args = {
    "--format=gcc",
    "-",
  },
  offsetLine = 0,
  offsetColumn = 0,
  sourceName = "shellcheck",
  formatLines = 1,
  formatPattern = {
    "^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
    {
      line = 1,
      column = 2,
      message = 4,
      security = 3,
    },
  },
  securities = {
    error = "error",
    warning = "warning",
    note = "info",
  },
}

linters.markdownlint = {
  command = "markdownlint",
  isStderr = true,
  debounce = 100,
  args = {
    "--stdin",
  },
  offsetLine = 0,
  offsetColumn = 0,
  sourceName = "markdownlint",
  formatLines = 1,
  formatPattern = {
    "^.*:\\s*(\\d+)\\s+(.*)$",
    {
      line = 1,
      column = -1,
      message = 2,
    },
  },
}

linters.mix_credo = {
  command = "mix",
  debounce = 100,
  rootPatterns = { "mix.exs" },
  args = {
    "credo",
    "suggest",
    "--strict",
    "--format",
    "flycheck",
    "--read-from-stdin",
  },
  offsetLine = 0,
  offsetColumn = 0,
  sourceName = "mix_credo",
  formatLines = 1,
  formatPattern = {
    "^[^ ]+?:([0-9]+)(:([0-9]+))?:\\s+([^ ]+):\\s+(.*)$",
    {
      line = 1,
      column = 3,
      message = 5,
      security = 4,
    },
  },
  securities = {
    F = "warning",
    C = "warning",
    D = "info",
    R = "info",
  },
}

linters.mix_credo_compile = {
  command = "mix",
  debounce = 100,
  rootPatterns = { "mix.exs" },
  args = {
    "credo",
    "suggest",
    "--strict",
    "--format",
    "flycheck",
    "--read-from-stdin",
  },
  offsetLine = -1,
  offsetColumn = 0,
  sourceName = "mix_credo",
  formatLines = 1,
  formatPattern = {
    "^([^ ]+)\\s+\\(([^)]+)\\)\\s+([^ ]+?):([0-9]+):\\s+(.*)$",
    {
      line = -1,
      column = -1,
      message = {
        "[",
        2,
        "]: ",
        3,
        ": ",
        5,
      },
      security = 1,
    },
  },
  securities = {
    ["**"] = "error",
  },
}

linters.vint = {
  command = "vint",
  debounce = 100,
  args = {
    "--enable-neovim",
    "%file",
  },
  offsetLine = 0,
  offsetColumn = 0,
  sourceName = "vint",
  formatLines = 1,
  formatPattern = {
    "[^:]+:(\\d+):(\\d+):\\s*(.*$)",
    {
      line = 1,
      column = 2,
      message = 3,
    },
  },
}

linters.languagetool = {
  command = "languagetool",
  debounce = 200,
  args = { "%file" },
  offsetLine = 0,
  offsetColumn = 0,
  sourceName = "languagetool",
  formatLines = 2,
  formatPattern = {
    "^\\d+?\\.\\)\\s+Line\\s+(\\d+),\\s+column\\s+(\\d+),\\s+([^\\n]+)\nMessage:\\s+(.*)$",
    {
      line = 1,
      column = 2,
      message = { 4 },
    },
  },
}

local linter_filetypes = {
  sh = "shellcheck",
  markdown = { "markdownlint", "languagetool" },
  vimwiki = { "markdownlint", "languagetool" },
  vim = "vint",
  elixir = {
    "mix_credo",
    "mix_credo_compile",
  },
  eelixir = {
    "mix_credo",
    "mix_credo_compile",
  },
  email = "languagetool",
}

local filetypes = {}

for k, _ in pairs(linter_filetypes) do
  table.insert(filetypes, k)
end

return {
  filetypes = filetypes,
  init_options = {
    linters = linters,
    filetypes = linter_filetypes,
  },
}
