if not pcall(require, "nvim-lightbulb") then
  return
end

require("nvim-lightbulb").setup({
  autocmd = { enabled = true },
  float = { enabled = false, text = "💡 Code action available" },
  virtual_text = { enabled = false },
})
