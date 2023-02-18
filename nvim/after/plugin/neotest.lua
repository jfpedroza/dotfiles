if not pcall(require, "neotest") or PLUGIN_DISABLE.neotest then
  return
end

local neotest = require("neotest")

neotest.setup({
  log_level = vim.log.levels.INFO,
  adapters = {
    require("neotest-elixir"),
    require("neotest-python"),
  },
  icons = {
    running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
  },
  consumers = {
    overseer = require("neotest.consumers.overseer"),
  },
  quickfix = {
    enabled = false,
  },
})

vim.api.nvim_create_user_command("Neotest", require("jp.neotest").run_suite, {})
vim.api.nvim_create_user_command("NeotestFile", require("jp.neotest").run_file, {})
vim.api.nvim_create_user_command("NeotestNearest", require("jp.neotest").run, {})
vim.api.nvim_create_user_command("NeotestLast", neotest.run.run_last, {})
vim.api.nvim_create_user_command("NeotestAttach", neotest.run.attach, {})
vim.api.nvim_create_user_command("NeotestSummary", neotest.summary.toggle, {})
vim.api.nvim_create_user_command("NeotestOutput", neotest.output.open, {})

vim.keymap.set("n", "<leader>t", require("jp.neotest").run)
vim.keymap.set("n", "<leader>T", require("jp.neotest").run_file)
vim.keymap.set("n", "<space>to", neotest.output.open)
vim.keymap.set("n", "<space>tl", neotest.run.run_last)

vim.cmd.cnoreabbrev("ntl NeotestLast")
vim.cmd.cnoreabbrev("nts NeotestSummary")
vim.cmd.cnoreabbrev("nto NeotestOutput")

local group = vim.api.nvim_create_augroup("NeotestConfig", {})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neotest-output,neotest-attach",
  group = group,
  callback = function(opts)
    vim.keymap.set("n", "q", function()
      pcall(vim.api.nvim_win_close, 0, true)
    end, {
      buffer = opts.buf,
    })
  end,
})
