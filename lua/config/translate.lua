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
