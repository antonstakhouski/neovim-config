-- translate_spinner.lua
-- Enhanced translation helper for Neovim

-- Spinner frames (Braille dots look nice in most terminals)
local spinner_frames = {
  "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏",
}

local spinner_timer ---@type uv_timer_t | nil
local spinner_index = 1

local function start_spinner()
  vim.api.nvim_echo({ { "Translating " .. spinner_frames[spinner_index], "None" } }, false, {})
  spinner_timer = vim.loop.new_timer()
  spinner_timer:start(0, 100, vim.schedule_wrap(function()
    spinner_index = spinner_index % #spinner_frames + 1
    vim.api.nvim_echo({ { "Translating " .. spinner_frames[spinner_index], "None" } }, false, {})
  end))
end

--- Stop the spinner and print a final message.
--- If successful, open Telescope pre‑filtered for `messages.po`.
---@param success boolean
local function stop_spinner(success)
  if spinner_timer then
    spinner_timer:stop()
    spinner_timer:close()
    spinner_timer = nil
  end
  if success then
    vim.api.nvim_echo({ { "Files translated successfully ✔", "None" } }, false, {})
    -- Open Telescope searching only for *messages.po* files
    require("telescope.builtin").find_files {
      default_text = "messages.po",
      prompt_title = "messages.po"
    }
  else
    vim.api.nvim_echo({ { "Error translating files ✖", "ErrorMsg" } }, false, {})
  end
end

--- Update all .po files by calling Flask‑Babel.
--- Uses an isolated bash shell so that `conda activate` works inside jobstart.
function UpdateTranslations()
  local command = "conda activate issa_debug && export FLASK_APP=issa && flask translate update"
  start_spinner()
  vim.fn.jobstart(command, {
    on_exit = function(_, exit_code)
      vim.schedule(function()
        stop_spinner(exit_code == 0)
      end)
    end,
  })
end

-- ╭─────────────────────────────────────────────╮
-- │ UX sugar: map keys + create :Translate cmd  │
-- ╰─────────────────────────────────────────────╯
vim.api.nvim_create_user_command("Translate", UpdateTranslations, {})
vim.keymap.set("n", "<F5>", "<cmd>Translate<CR>", { noremap = true, silent = true })

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
