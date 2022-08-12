if not pcall(require, "luasnip") then
  return
end

local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.set_config({
  history = true,
  update_events = "TextChanged,TextChangedI",
  enable_autosnippets = true,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " <- Current Choice", "NonTest" } },
      },
    },
  },
})

require("luasnip.loaders.from_snipmate").lazy_load()

-- TODO: Find or create snippets for date, datetime and uuid
