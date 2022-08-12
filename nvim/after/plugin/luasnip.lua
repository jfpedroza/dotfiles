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

local snippet = ls.s
local i, c, t, f = ls.insert_node, ls.choice_node, ls.text_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local same = function(index)
  return f(function(arg)
    return arg[1]
  end, { index })
end

ls.add_snippets("all", {
  snippet(
    "time",
    f(function()
      return os.date("%H:%M")
    end)
  ),
})

ls.add_snippets("lua", {
  snippet(
    "req",
    fmt([[local {} = require("{}")]], {
      f(function(import_name)
        local parts = vim.split(import_name[1][1], ".", true)
        return parts[#parts]
      end, { 1 }),
      i(1),
    })
  ),
})

-- Test and exmaple snippets
ls.add_snippets("all", {
  snippet("sametest", fmt([[example: {}, function: {}]], { i(1), same(1) })),
  snippet("choicetest", fmt("Choose: {}", { c(1, { t("one"), t("two"), t("three") }) })),
})

-- TODO: Find or create snippets for date, datetime and uuid

-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes
vim.keymap.set("i", "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set("i", "<c-u>", require("luasnip.extras.select_choice"))
