if not pcall(require, "neotest") then
  return
end

local neotest = require("neotest")

neotest.setup({
  adapters = {
    require("neotest-elixir"),
  },
})

local function run(arg)
  local default_env = vim.g.neotest_run_env or {}
  local args

  if type(arg) == "table" then
    local env = arg.env or {}
    arg.env = vim.tbl_extend("force", default_env, env)
    args = arg
  else
    args = { arg, env = default_env }
  end

  neotest.run.run(args)
end

vim.api.nvim_create_user_command("NeotestFile", function()
  run(vim.fn.expand("%"))
end, {})

vim.api.nvim_create_user_command("Neotest", function()
  run(vim.fn.getcwd())
end, {})

vim.api.nvim_create_user_command("NeotestNearest", run, {})

vim.api.nvim_create_user_command("NeotestLast", neotest.run.run_last, {})
vim.api.nvim_create_user_command("NeotestAttach", neotest.run.attach, {})
vim.api.nvim_create_user_command("NeotestSummary", neotest.summary.toggle, {})
vim.api.nvim_create_user_command("NeotestOutput", neotest.output.open, {})
