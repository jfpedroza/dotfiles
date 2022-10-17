local has_lsp, lspconfig = pcall(require, "lspconfig")
if not has_lsp then
  return
end

local lsp_status = require("lsp-status")
require("jp.lsp.status").activate()

local show_documentation = function(bufnr)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  if filetype == "lua" then
    local line = vim.api.nvim_get_current_line()
    if vim.regex([[vim\.\([bwg]\?o\|opt\|api\)\.]]):match_str(line) then
      vim.cmd.help(vim.fn.expand("<cword>"))
      return
    end
  end

  vim.lsp.buf.hover()
end

local custom_attach = function(client, bufnr)
  local bufopts = { buffer = bufnr, silent = true }
  vim.keymap.set("n", "<leader>d", function()
    require("nvim-treesitter-refactor.navigation").goto_definition(nil, function()
      vim.lsp.buf.definition({ reuse_win = true })
    end)
  end, bufopts)
  vim.keymap.set("n", "<leader>dt", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>di", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<leader>dr", "<cmd>Telescope lsp_references<CR>", bufopts)
  vim.keymap.set("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", bufopts)
  vim.keymap.set("n", "<leader>ac", vim.lsp.buf.code_action, bufopts)

  if client.server_capabilities.renameProvider then
    vim.keymap.set("n", "<leader>re", vim.lsp.buf.rename, bufopts)
  end

  vim.keymap.set("n", "K", function()
    show_documentation(bufnr)
  end, bufopts)

  lsp_status.on_attach(client)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- capabilities = vim.tbl_extend("keep", capabilities, lsp_status.capabilities)
capabilities.window = {
  workDoneProgress = true,
}


require("neodev").setup({})

local servers = {
  sumneko_lua = true,
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
    capabilities = capabilities,
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
  capabilities = capabilities,
})
