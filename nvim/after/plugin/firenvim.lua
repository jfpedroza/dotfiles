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
    ["^https://app\\.gather\\.town/"] = {
      takeover = "never",
      priority = 1,
    },
    ["^https://onedrive\\.live\\.com/"] = {
      takeover = "never",
      priority = 1,
    },
  },
}

-- From: https://github.com/stevearc/dotfiles/blob/master/.config/nvim/plugin/firenvim.lua
local timer = nil
local function throttle_write(delay)
  local bufnr = vim.api.nvim_get_current_buf()
  if timer then
    timer:close()
  end
  timer = vim.loop.new_timer()
  timer:start(
    delay or 1000,
    0,
    vim.schedule_wrap(function()
      timer:close()
      timer = nil
      if vim.api.nvim_buf_get_option(bufnr, "modified") then
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd("write")
        end)
      end
    end)
  )
end

if vim.g.started_by_firenvim then
  vim.o.laststatus = 0

  local group = vim.api.nvim_create_augroup("FireNvimFT", {})
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.*",
    once = true,
    group = group,
    callback = function()
      -- We wait to call this function until the firenvim buffer is loaded
      local buf_group = vim.api.nvim_create_augroup("FireNvimWrite", {})
      vim.api.nvim_create_autocmd({ "FocusLost", "TextChanged", "TextChangedI" }, {
        buffer = vim.api.nvim_get_current_buf(),
        nested = true,
        group = buf_group,
        callback = function(params)
          local delay = params.event == "FocusLost" and 10 or 1000
          throttle_write(delay)
        end,
      })
      -- These create unnecessary autocmds for BufWritePre and BufWritePost
      -- By clearing them, we can improve the performance of :write
      local unnecessary_groups = { "filetypedetect", "gzip" }
      for _, name in ipairs(unnecessary_groups) do
        local ok, err = pcall(vim.api.nvim_del_augroup_by_name, name)
        if not ok then
          vim.notify(string.format("Could not delete augroup '%s'", name), vim.log.levels.WARN)
        end
      end
    end,
  })
end
