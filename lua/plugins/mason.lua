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

      -- Setup typescript-language-server
      lspconfig.ts_ls.setup {
        settings = {
          typescript = {
            preferences = {
              preferTypeOnlyAutoImports = true,
            },
          },
        },
      }

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
          format = { enable = true },
        },
        on_attach = function(client, bufnr)
          ---------------------------------------------------------------------------
          -- 1. keep ESLint’s formatting capability ON
          ---------------------------------------------------------------------------
          client.server_capabilities.documentFormattingProvider = true

          ---------------------------------------------------------------------------
          -- 2. format-on-save for ESLint only
          ---------------------------------------------------------------------------
          local eslint_grp = vim.api.nvim_create_augroup("EslintFix", { clear = true })
          vim.api.nvim_clear_autocmds({ group = eslint_grp, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group   = eslint_grp,
            buffer  = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr  = bufnr,
                filter = function(c) return c.name == "eslint" end,  -- << ESLint only
              })
            end,
          })
        end,
      }
    end,
  },
}
