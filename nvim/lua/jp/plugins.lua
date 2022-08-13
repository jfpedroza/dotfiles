local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
local packer_bootstrap

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
end

vim.cmd([[packadd packer.nvim]])
local startup = require("packer").startup

startup({
  function(use)
    use({ "wbthomason/packer.nvim", opt = true })
    use("tpope/vim-repeat")
    use({
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    })
    use("tpope/vim-abolish")
    use("vim-airline/vim-airline")
    use("simnalamburt/vim-mundo")
    use("tpope/vim-fugitive")
    use("tpope/vim-rhubarb")
    use("tpope/vim-unimpaired")
    use("tpope/vim-obsession")
    use("junegunn/fzf.vim")
    use("mileszs/ack.vim")
    use("Chiel92/vim-autoformat")
    use("skywind3000/asyncrun.vim")
    use({
      "kyazdani42/nvim-tree.lua",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
      tag = "nightly",
    })
    use({ "vimwiki/vimwiki", branch = "dev" })
    use("tbabej/taskwiki")
    use("tpope/vim-surround")
    use("christoomey/vim-system-copy")
    use("Raimondi/delimitMate")
    use("lag13/ReplaceWithRegister")
    use("michaeljsmith/vim-indent-object")
    use({ "rhysd/git-messenger.vim", cmd = "GitMessenger", keys = { "<Plug>(git-messenger)" } })
    use("AndrewRadev/splitjoin.vim")
    use("vim-scripts/argtextobj.vim")
    use("kshenoy/vim-signature")
    use("easymotion/vim-easymotion")
    use("majutsushi/tagbar")
    use("editorconfig/editorconfig-vim")
    use("voldikss/vim-floaterm")
    use({ "nvim-telescope/telescope.nvim", branch = "0.1.x", requires = { { "nvim-lua/plenary.nvim" } } })
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use("nvim-telescope/telescope-ui-select.nvim")
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use("nvim-treesitter/nvim-treesitter-refactor")
    use("rcarriga/nvim-notify")

    -- Languages
    use("neovim/nvim-lspconfig")
    use({ "neoclide/coc.nvim", branch = "release" })
    use("sheerun/vim-polyglot")
    use("alx741/vim-hindent")
    use("pbrisbin/vim-syntax-shakespeare")
    use("vhdirk/vim-cmake")
    use({ "raimon49/requirements.txt.vim", ft = "requirements" })
    use("tridactyl/vim-tridactyl")
    use("aklt/plantuml-syntax")
    use({ "iamcco/markdown-preview.nvim", run = "cd app && yarn install" })
    use("vim-test/vim-test")

    -- Completion
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lua")
    use("onsails/lspkind.nvim")

    -- Snippets
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")
    use("honza/vim-snippets")

    -- Authomatically set up configuration after cloning packer.nvim
    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    max_jobs = 30,
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "single" })
      end,
    },
  },
})
