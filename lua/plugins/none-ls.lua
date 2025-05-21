return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls  = require("null-ls")
      local utils    = require("null-ls.utils")

      -- 1. Create (or fetch) the group **once**
      local formatting_grp = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

      null_ls.setup({
        root_dir = utils.root_pattern(
          "app/static/eslint.config.mjs",
          ".prettierrc",
          ".git"
        ),

        sources = {
          null_ls.builtins.formatting.prettierd.with({
            filetypes = {
              "javascript",
              "typescript",
              "javascriptreact",
              "typescriptreact",
              "scss",
            },
            prefer_local = "node_modules/.bin",
          }),

          -- null_ls.builtins.formatting.black.with({
          --   filetypes = { "python" },
          --   prefer_local = "bin",
          -- }),
        },

        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            -- 2. Clear any old autocommands **for this buffer** in that group
            vim.api.nvim_clear_autocmds({ group = formatting_grp, buffer = bufnr })

            -- 3. Add (or re-add) the format-on-save autocommand
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = formatting_grp,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  filter = function(c) return c.name == "null-ls" end,
                })
              end,
            })
          end
        end,
      })
    end,
  },
}
