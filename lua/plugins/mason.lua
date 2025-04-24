return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "VonHeikemen/lsp-zero.nvim",
    },
    config = function()
      require("mason").setup()

      require("mason-lspconfig").setup({
        handlers = {
          require("lsp-zero").default_setup,
        }
      })

      local lspconfig = require('lspconfig')

      -- Setup eslint-lsp
      lspconfig.eslint.setup {
        -- Custom function to set the root directory
        root_dir = function(fname)
          return lspconfig.util.root_pattern('app/static/eslint.config.mjs')(fname)
          or lspconfig.util.root_pattern('.git')(fname)
          or lspconfig.util.path.dirname(fname)
        end,
        settings = {
          workingDirectory = { mode = 'location' }, -- Use the config file's location
        },
        on_attach = function(client, bufnr)
          -- Turn OFF formatting so ESLint only provides diagnostics/code-actions
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      }
    end,
  },
}
