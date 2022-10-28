if not pcall(require, "bufferline") then
  return
end

if vim.g.started_by_firenvim then
  return
end

require("bufferline").setup()
