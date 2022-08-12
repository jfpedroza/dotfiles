if not pcall(require, "telescope") then
  return
end

require("telescope").load_extension("fzf")

local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
    },
    mappings = {
      i = {
        ["<Esc>"] = actions.close,
      },
    },
  },
})

vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#303030" })
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.wo.number = true
  end,
})

local M = {}

function M.find_files()
  require("telescope.builtin").find_files({
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function(prompt_bufnr)
        local state = require("telescope.actions.state")
        local picker = state.get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()
        local single = picker:get_selection()
        local str = ""

        if #multi > 0 then
          for i, j in pairs(multi) do
            str = str .. "edit " .. j[1] .. " | "
          end
        else
          str = "edit " .. single[1]
        end

        -- To avoid populating qf or doing ":edit! file", close the prompt first
        actions.close(prompt_bufnr)
        vim.api.nvim_command(str)
      end)

      return true
    end,
  })
end

local pickers = setmetatable({}, {
  __index = function(_, k)
    if M[k] then
      return M[k]
    else
      return function()
        require("telescope.builtin")[k]()
      end
    end
  end,
})

vim.keymap.set("n", "<leader>bb", pickers.buffers, { desc = "Show buffers on Telescope" })
vim.keymap.set("n", "<leader>f", pickers.find_files, { desc = "Find files using Telescope" })