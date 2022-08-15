local ok, signs = pcall(require, "gitsigns")
if not ok then
  return
end

signs.setup({
  numhl = false,
  linehl = false,
  word_diff = false,

  on_attach = function(bufnr)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr

      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        signs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        signs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    -- Actions
    map({ "n", "v" }, "<leader>cs", ":Gitsigns stage_hunk<CR>")
    map({ "n", "v" }, "<leader>cu", ":GitSigns reset_hunk<CR>")
    map("n", "<leader>cp", signs.preview_hunk)
    map("n", "<leader>cd", signs.toggle_deleted)
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
})
