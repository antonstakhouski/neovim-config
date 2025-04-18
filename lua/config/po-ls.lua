-- po-complier will check .po file for fuzzy and untranslated strings
local group = vim.api.nvim_create_augroup('po-compiler', { clear = true })

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.po',
  group   = group,
  callback = function()
    -- load the compiler script we just created
    vim.cmd('compiler po')
  end,
})

-- Show diagnistics using LSP
local null_ls = require('null-ls')
local h = require("null-ls.helpers")

null_ls.register({
  name     = "po-lint",
  method   = null_ls.methods.DIAGNOSTICS,
  filetypes= { "po" },
  generator = h.generator_factory({
    command       = "po-lint",
    args          = { "$FILENAME" },
    format        = "line",          -- FILE:LINE:COL: {warning|error}: MSG
    to_stdin      = false,
    to_temp_file  = true,
    on_output     = h.diagnostics.from_patterns({
      {
        pattern = "([^:]+):(%d+):(%d+):%s+info:%s+(.*)",
        groups  = { "filename", "row", "col", "message" },
        severity = vim.diagnostic.severity.INFO,
      },
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

-- -- (optional) a very light debounce so we don't spawn po‑lint *too* often
null_ls.setup({
  debounce = 250,          -- ms between the last keystroke and lint run
  update_in_insert = false -- wait until you leave insert mode
})
