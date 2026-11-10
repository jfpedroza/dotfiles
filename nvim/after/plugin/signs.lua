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
    map({ "n", "v" }, "<leader>cu", ":Gitsigns reset_hunk<CR>")
    map("n", "<leader>cp", signs.preview_hunk)
    map("n", "<leader>cd", signs.toggle_deleted)
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
})

vim.api.nvim_create_user_command("Gstage", function(opts)
  if opts.range == 0 then
    signs.stage_hunk()
  else
    signs.stage_hunk({ opts.line1, opts.line2 })
  end
end, { range = true, desc = "Stage the selected lines, or the hunk under the cursor without a range" })
