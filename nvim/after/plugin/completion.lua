local has_cmp, cmp = pcall(require, "cmp")
if not has_cmp then
  return
end

local lspkind = require("lspkind")

vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Don't give |ins-completion-menu| messages.
vim.opt.shortmess:append("c")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<c-y>"] = cmp.mapping(
      cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
      { "i", "c" }
    ),
    ["<c-space>"] = cmp.mapping({
      i = cmp.mapping.complete(),
      c = function(
        _ --[[fallback]]
      )
        if cmp.visible() then
          if not cmp.confirm({ select = true }) then
            return
          end
        else
          cmp.complete()
        end
      end,
    }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lua" },
  }, {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  }, {
    { name = "buffer", keyword_length = 3 },
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      maxwidth = 50,
      menu = {
        buffer = "[buf]",
        path = "[path]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[api]",
        luasnip = "[snip]",
      },
    }),
  },
})
