local has_lsp, lspconfig = pcall(require, "lspconfig")
if not has_lsp or PLUGIN_DISABLE.lsp then
  return
end

if vim.g.started_by_firenvim then
  return
end

local lsp_status = require("lsp-status")
require("jp.lsp.status").activate()

local has_ufo, ufo = pcall(require, "ufo")

local show_documentation = function(bufnr)
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
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
    local winid
    if has_ufo and not PLUGIN_DISABLE.ufo then
      winid = ufo.peekFoldedLinesUnderCursor()
    end

    if not winid then
      show_documentation(bufnr)
    end
  end, bufopts)

  lsp_status.on_attach(client)

  if client.name == "ruff" then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- capabilities = vim.tbl_extend("keep", capabilities, lsp_status.capabilities)
capabilities.window = {
  workDoneProgress = true,
}

if has_ufo and not PLUGIN_DISABLE.ufo then
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
end

require("neodev").setup({
  override = function(root_dir, library)
    if vim.endswith(root_dir, "/neotest-elixir") then
      library.plugins = { "neotest" }
    end
  end,
})

local servers = {
  lua_ls = true,
  vimls = true,
  solargraph = true,
  pyright = {
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          -- Ignore all files for analysis to exclusively use Ruff for linting
          -- ignore = { "*" },
        },
      },
    },
  },
  ruff = true,
  rust_analyzer = true,
  jsonls = true,
  html = true,
  cssls = true,
  eslint = true,
  ts_ls = true,
  yamlls = true,
  ccls = true,
  bashls = true,
  hls = true,
  ltex_plus = {
    settings = {
      ltex = {
        language = "en-US",
        dictionary = {
          ["en-US"] = {
            "Redpanda",
            "Oban",
            "PubSub",
            "LiveView",
            "AppSignal",
            "TODO",
          },
        },
        markdown = {
          nodes = {
            CodeBlock = "ignore",
            FencedCodeBlock = "ignore",
            AutoLink = "dummy",
            Code = "dummy",
          },
        },
      },
    },
  },
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
local elixirls = require("elixir.elixirls")

local elixirls_cmd
local elixirls_tag
if vim.env.ELIXIRLS_LOCAL ~= "true" then
  elixirls_cmd = vim.fn.expand("~/code/lib/elixir-ls/release/language_server.sh")
else
  elixirls_tag = "v0.27.2"
end

elixir.setup({
  elixirls = {
    enable = true,
    tag = elixirls_tag,
    cmd = elixirls_cmd,
    settings = elixirls.settings({
      dialyzerEnabled = true,
      dialyzerFormat = "dialyxir_long",
      suggestSpecs = true,
      enableTestLenses = true,
    }),
    on_attach = custom_attach,
    capabilities = capabilities,
  },
  credo = { enable = false },
  nextls = { enable = false },
})
