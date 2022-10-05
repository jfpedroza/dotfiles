local M = {}

M.env = nil

function M.run(arg)
  local default_env = M.env or {}
  local args

  if type(arg) == "table" then
    local env = arg.env or {}
    arg.env = vim.tbl_extend("force", default_env, env)
    args = arg
  else
    args = { arg, env = default_env }
  end

  print("Neotest run called with arg", args[1])
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

function M.read_env(...)
  M.env = vim.fn.DotenvRead(...)
end

return M
