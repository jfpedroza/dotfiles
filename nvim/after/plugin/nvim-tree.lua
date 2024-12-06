if not pcall(require, "nvim-tree") then
  return
end

local nt_api = require("nvim-tree.api")

local function live_grep()
  local node = nt_api.tree.get_node_under_cursor()
  require("telescope.builtin").live_grep({
    prompt_title = "Live Grep (" .. vim.fn.fnamemodify(node.absolute_path, ":~:.") .. ")",
    search_dirs = { node.absolute_path },
  })
end

local function custom_attach(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  nt_api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "<leader>s", live_grep, opts("Live grep"))
end

require("nvim-tree").setup({
  on_attach = custom_attach,
})

vim.keymap.set("n", "<F5>", function()
  nt_api.tree.toggle({ find_file = true })
end, { desc = "Toggle file explorer" })
