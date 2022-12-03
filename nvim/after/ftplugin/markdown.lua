if vim.g.started_by_firenvim then
  return
end

vim.bo.textwidth = 120

-- Add the key mappings only for Markdown files in a zk notebook.
if require("zk.util").notebook_root(vim.fn.expand("%:p")) ~= nil then
  -- Open the link under the caret.
  vim.keymap.set("n", "<CR>", function()
    vim.lsp.buf.definition({ reuse_win = true })
  end, { buffer = true })

  -- Create a note using the selection as title or content
  vim.keymap.set("v", "<leader>zn", ":lua zk_new_note_selection()<CR>", { buffer = true })

  -- Preview a linked note.
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover()
  end, { buffer = true })

  -- Open the code actions for a visual selection.
  vim.keymap.set("v", "<leader>ac", "<CMD>lua vim.lsp.buf.code_action()<CR>", { buffer = true })
end
