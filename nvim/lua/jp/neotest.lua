local M = {}

function M.run(arg)
  local default_env = vim.g.neotest_run_env or {}
  local args

  if type(arg) == "table" then
    local env = arg.env or {}
    arg.env = vim.tbl_extend("force", default_env, env)
    args = arg
  else
    args = { arg, env = default_env }
  end

  require("neotest").run.run(args)
end

function M.run_file(args)
  args = args or {}
  args[1] = vim.fn.expand("%")
  M.run(args)
end

function M.run_suite(args)
  args = args or {}
  args[1] = vim.fn.getcwd()
  M.run(args)
end

return M
