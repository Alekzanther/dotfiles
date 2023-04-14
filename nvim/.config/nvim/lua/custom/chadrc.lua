-- First read our docs (completely) then check the example_config repo

local M = {}

M.ui = {
  theme = "catppuccin",
}

M.plugins = {

  ["neovim/nvim-lspconfig"] = {
      config = function()
        require "plugins.configs.lspconfig"
        require "custom.plugins.lspconfig"
      end,
  },
  ["williamboman/mason.nvim"] = {
   override_options = {
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",

        -- web dev
        "css-lsp",
        "html-lsp",
        "typescript-language-server",
        "prettierd",
        "eslint_d",

        -- docker
        "dockerfile-language-server",

        -- shell
        "shfmt",
        "shellcheck",
      },
    },
  },
  ["jose-elias-alvarez/null-ls.nvim"] = {
      after = "nvim-lspconfig",
      config = function()
         require "custom.plugins.null-ls"
      end,
   }
}

return M
