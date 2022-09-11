if not pcall(require, "telescope") then
  return
end

local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
    },
    dynamic_preview_title = true,
    mappings = {
      i = {
        ["<Esc>"] = actions.close,
      },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
  },
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("notify")
require("telescope").load_extension("dap")
require("telescope").load_extension("harpoon")

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

function M.yank_history()
  require("yanky.telescope.yank_history").yank_history({})
end

function M.edit_neovim()
  require("telescope.builtin").find_files({
    prompt_title = "~ dotfiles ~",
    cwd = "~/.config/nvim",
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

vim.keymap.set("n", "<leader>b", pickers.buffers, { desc = "Show buffers on Telescope" })
vim.keymap.set("n", "<leader>f", pickers.find_files, { desc = "Find files using Telescope" })
vim.keymap.set("n", "<leader>;", pickers.edit_neovim, { desc = "Find Neovim files using Telescope" })
vim.keymap.set("n", "<leader>s", pickers.live_grep, { desc = "Find string using Telescope" })
vim.keymap.set("n", "<leader>y", pickers.yank_history, { desc = "Show yank history using Telescope" })
