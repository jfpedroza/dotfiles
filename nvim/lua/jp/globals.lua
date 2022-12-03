if pcall(require, "plenary") then
  RELOAD = require("plenary.reload").reload_module

  R = function(module)
    RELOAD(module)
    return require(module)
  end
end

P = function(v)
  print(vim.inspect(v))
  return v
end

PLUGIN_DISABLE = {}
