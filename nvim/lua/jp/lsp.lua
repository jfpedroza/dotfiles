local has_lsp, lspconfig = pcall(require, "lspconfig")
if not has_lsp then
  return
end

local show_documentation = function(bufnr)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  if filetype == "lua" then
    local line = vim.api.nvim_get_current_line()
    if vim.regex([[vim\.\([bwg]\?o\|opt\|api\)\.]]):match_str(line) then
      vim.cmd("help " .. vim.fn.expand("<cword>"))
      return
    end
  end

  vim.lsp.buf.hover()
end

local custom_attach = function(_client, bufnr)
  local bufopts = { buffer = bufnr, silent = true }
  vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "<leader>dt", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>di", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<leader>dr", "<cmd>Telescope lsp_references<CR>", bufopts)
  vim.keymap.set("n", "<leader>re", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>ac", vim.lsp.buf.code_action, bufopts)

  vim.keymap.set("n", "K", function()
    show_documentation(bufnr)
  end, bufopts)

  -- Move outside the function when CoC is removed
  vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set("n", "]g", vim.diagnostic.goto_next, bufopts)
end

local servers = {
  elixirls = {
    cmd = { vim.fn.expand("~/code/lib/elixir-ls/release/language_server.sh") },
    settings = {
      elixirLS = {
        dialyzerEnabled = true,
        dialyzerFormat = "dialyxir_long",
      },
    },
  },
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
  vimls = true,
}

local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  config = vim.tbl_deep_extend("force", {
    on_attach = custom_attach,
  }, config)

  lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end
