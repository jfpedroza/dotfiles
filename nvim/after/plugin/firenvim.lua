vim.g.firenvim_config = {
  globalSettings = {
    alt = "all",
  },
  localSettings = {
    [".*"] = {
      cmdline = "firenvim",
      content = "text",
      priority = 0,
      selector = "textarea",
      takeover = "always",
    },
    ["^https://docs\\.google\\.com/"] = {
      takeover = "never",
      priority = 1,
    },
    ["^https://meet\\.google\\.com/"] = {
      takeover = "never",
      priority = 1,
    },
  },
}

if vim.g.started_by_firenvim then
  vim.o.laststatus = 0
end
