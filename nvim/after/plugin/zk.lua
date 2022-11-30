if not pcall(require, "zk") then
  return
end

require("zk").setup({
  picker = "telescope",
})
