if not pcall(require, "yanky") then
  return
end

local utils = require("yanky.utils")
local mapping = require("yanky.telescope.mapping")

require("yanky").setup({
  ring = {
    filter = function(entry)
      return #entry.regcontents > 3 and not entry.regcontents:match("^[%s\n]*$")
    end,
  },
  system_clipboard = {
    sync_with_ring = false,
  },
  highlight = {
    timer = 300,
  },
  picker = {
    telescope = {
      -- Override default mappings because changing <c-p> is an aberration
      mappings = {
        default = mapping.put("p"),
        i = {
          ["<c-k>"] = mapping.put("P"),
          ["<c-x>"] = mapping.delete(),
          ["<c-r>"] = mapping.set_register(utils.get_default_register()),
        },
        n = {
          p = mapping.put("p"),
          P = mapping.put("P"),
          d = mapping.delete(),
          r = mapping.set_register(utils.get_default_register()),
        },
      },
    },
  },
})

-- Due to load order this can't be in telescope.lua (yanky setup must happen before extension load)
require("telescope").load_extension("yank_history")
