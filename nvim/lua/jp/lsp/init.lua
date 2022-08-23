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

local custom_attach = function(client, bufnr)
  local bufopts = { buffer = bufnr, silent = true }
  vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "<leader>dt", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>di", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<leader>dr", "<cmd>Telescope lsp_references<CR>", bufopts)
  vim.keymap.set("n", "<leader>ac", vim.lsp.buf.code_action, bufopts)

  if client.server_capabilities.renameProvider then
    vim.keymap.set("n", "<leader>re", vim.lsp.buf.rename, bufopts)
  end

  vim.keymap.set("n", "K", function()
    show_documentation(bufnr)
  end, bufopts)
end

local updated_capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local servers = {
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
  solargraph = true,
  pyright = true,
  rls = true,
  jsonls = true,
  html = true,
  cssls = true,
  eslint = true,
  tsserver = true,
  yamlls = true,
  ccls = true,
  diagnosticls = require("jp.lsp.diagnosticls"),
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
    capabilities = updated_capabilities,
  }, config)

  lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end

local elixir = require("elixir")

elixir.setup({
  settings = elixir.settings({
    dialyzerEnabled = true,
    dialyzerFormat = "dialyxir_long",
    suggestSpecs = true,
    enableTestLenses = true,
  }),
  on_attach = custom_attach,
  capabilities = updated_capabilities,
})
