local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "tpope/vim-repeat",
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  "tpope/vim-abolish",
  "feline-nvim/feline.nvim",
  { "akinsho/bufferline.nvim", version = "*", dependencies = { "nvim-tree/nvim-web-devicons" } },
  "simnalamburt/vim-mundo",
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "tpope/vim-unimpaired",
  "tpope/vim-obsession",
  "tpope/vim-projectionist",
  "tpope/vim-dotenv",
  "junegunn/fzf",
  "junegunn/fzf.vim",
  "mileszs/ack.vim",
  "Chiel92/vim-autoformat",
  { "nvim-tree/nvim-tree.lua", tag = "v1", dependencies = { "nvim-tree/nvim-web-devicons" } },
  {
    "vimwiki/vimwiki",
    init = function()
      vim.g.vimwiki_list = { { path = "~/vimwiki/", syntax = "markdown", ext = ".md" } }
      vim.g.vimwiki_global_ext = 0
    end,
  },
  "mickael-menu/zk-nvim",
  "godlygeek/tabular",
  "tpope/vim-surround",
  "christoomey/vim-system-copy",
  "Raimondi/delimitMate",
  "lag13/ReplaceWithRegister",
  "michaeljsmith/vim-indent-object",
  { "rhysd/git-messenger.vim", cmd = "GitMessenger", keys = { "<Plug>(git-messenger)" } },
  "AndrewRadev/splitjoin.vim",
  "vim-scripts/argtextobj.vim",
  "kshenoy/vim-signature",
  { "phaazon/hop.nvim", branch = "v2" },
  -- {"smoka7/hop.nvim", version="*" }, Pending migration to fork
  "majutsushi/tagbar",
  "voldikss/vim-floaterm",
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { { "nvim-lua/plenary.nvim" } } },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-treesitter/playground",
  "nvim-treesitter/nvim-treesitter-refactor",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "stevearc/dressing.nvim",
  "rcarriga/nvim-notify",
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup(nil, { css = true })
    end,
  },
  { dir = "~/code/lib/yanky.nvim", dependencies = { "kkharji/sqlite.lua" } },
  { "lewis6991/gitsigns.nvim" },
  { "antoinemadec/FixCursorHold.nvim" },
  { "ThePrimeagen/harpoon" },
  { "catppuccin/nvim", name = "catppuccin", build = ":CatppuccinCompile" },
  "folke/trouble.nvim",
  { "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async" },
  "stevearc/overseer.nvim",
  {
    "jpalardy/vim-slime",
    config = function()
      vim.g.slime_target = "tmux"
    end,
  },

  -- Languages
  "neovim/nvim-lspconfig",
  "nvim-lua/lsp-status.nvim",
  "kosayoda/nvim-lightbulb",
  "elixir-tools/elixir-tools.nvim",
  "sheerun/vim-polyglot",
  "alx741/vim-hindent",
  "pbrisbin/vim-syntax-shakespeare",
  "vhdirk/vim-cmake",
  "raimon49/requirements.txt.vim",
  "tridactyl/vim-tridactyl",
  "aklt/plantuml-syntax",
  { "weirongxu/plantuml-previewer.vim", dependencies = "tyru/open-browser.vim" },
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install" },
  {
    -- Make sure to set this up properly if you have lazy=true
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "Avante" },
    },
    ft = { "markdown", "Avante" },
  },
  "folke/neodev.nvim",
  {
    "stevearc/vim-arduino",
    config = function()
      vim.g.arduino_serial_cmd = "picocom {port} -b {baud} -l"
      vim.g.arduino_use_slime = 1
    end,
  },

  -- Completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lsp",
  -- "hrsh7th/cmp-nvim-lua",
  "onsails/lspkind.nvim",
  "hrsh7th/cmp-nvim-lsp-document-symbol",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "davidsierradz/cmp-conventionalcommits",

  -- Snippets
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "honza/vim-snippets",

  -- Testing
  { dir = "~/code/lib/neotest" },
  { dir = "~/code/nvim_plugins/neotest-elixir" },
  { "nvim-neotest/neotest-python" },

  -- Debugger Adapter Protocol
  { "mfussenegger/nvim-dap", dependencies = "nvim-neotest/nvim-nio" },
  "rcarriga/nvim-dap-ui",
  "theHamsta/nvim-dap-virtual-text",
  "nvim-telescope/telescope-dap.nvim",

  -- Turn textareas in Firefox into Neovim instances
  {
    "glacambre/firenvim",
    build = function()
      vim.fn["firenvim#install"](0)
    end,
  },

  -- AI plugin
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = "*",
    opts = {
      provider = "openai",
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "o3-mini",
        timeout = 30000,
        temperature = 0,
        -- max_tokens = 4096,
        -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  },
})
