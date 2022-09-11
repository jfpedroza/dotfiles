if not pcall(require, "harpoon") then
  return
end

require("harpoon").setup({
  menu = {
    width = 90,
  },
})

vim.keymap.set("n", "<space>h", function()
  require("harpoon.ui").toggle_quick_menu()
end, {})

vim.keymap.set("n", "<space>m", function()
  require("harpoon.mark").add_file()
end, {})

vim.keymap.set("n", "д", function() -- Mod3 + 1
  require("harpoon.ui").nav_file(1)
end, {})

vim.keymap.set("n", "ж", function() -- Mod3 + 2
  require("harpoon.ui").nav_file(2)
end, {})

vim.keymap.set("n", "о", function() -- Mod3 + 3
  require("harpoon.ui").nav_file(3)
end, {})

vim.keymap.set("n", "н", function() -- Mod3 + 4
  require("harpoon.ui").nav_file(4)
end, {})

vim.keymap.set("n", "п", function() -- Mod3 + 5
  require("harpoon.ui").nav_file(5)
end, {})
