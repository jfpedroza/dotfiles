local ok, overseer = pcall(require, "overseer")

if not ok then
  return
end

overseer.setup({
  task_list = {
    bindings = {
      ["<C-l>"] = false,
      ["<C-h>"] = false,
    },
  },
})

vim.keymap.set("n", "<F4>", function()
  overseer.toggle()
end)

vim.keymap.set("n", "<leader>o", function()
  vim.cmd.OverseerQuickAction("open float")
end)

overseer.register_template({
  name = "Interactive tests",
  builder = function(params)
    return {
      cmd = { "mix" },
      args = { "test.interactive", params.pattern or "" },
      name = "Interactive tests",
      env = require("jp.neotest").env or {},
    }
  end,
  tags = { overseer.TAG.TEST },
  params = {
    pattern = {
      type = "string",
    },
  },
  condition = {
    filetype = { "elixir", "eelixir" },
  },
})
