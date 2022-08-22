local custom_heuristics = {
  ["nvim/"] = {
    ["nvim/after/plugin/*.lua"] = {
      type = "after",
      template = {
        'if not pcall(require, "{}") then',
        "  return",
        "end",
        "",
        'require("{}").setup()',
      },
    },
  },
}

local new_heuristics
if vim.g.projectionist_heuristics then
  new_heuristics = vim.tbl_extend("error", vim.g.projectionist_heuristics, custom_heuristics)
else
  new_heuristics = custom_heuristics
end

vim.g.projectionist_heuristics = new_heuristics
