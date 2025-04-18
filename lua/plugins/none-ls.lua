return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require('null-ls')
      local h = require("null-ls.helpers")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettierd,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })

      null_ls.register({
        name     = "po-lint",
        method   = null_ls.methods.DIAGNOSTICS,
        filetypes= { "po" },
        generator = h.generator_factory({
          command       = "po-lint",
          args          = { "$FILENAME" },
          format        = "line",          -- FILE:LINE:COL: {warning|error}: MSG
          to_stdin      = false,
          on_output     = h.diagnostics.from_patterns({
            {
              pattern = "([^:]+):(%d+):(%d+):%s+warning:%s+(.*)",
              groups  = { "filename", "row", "col", "message" },
              severity = vim.diagnostic.severity.WARN,
            },
            {
              pattern = "([^:]+):(%d+):(%d+):%s+error:%s+(.*)",
              groups  = { "filename", "row", "col", "message" },
              severity = vim.diagnostic.severity.ERROR,
            },
          }),
          check_exit_code = function() return true end, -- we parse stdout only
        }),
      })
    end,
  },
}
