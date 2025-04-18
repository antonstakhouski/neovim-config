-- ~/.config/nvim/lua/po_jump.lua
local M = {}

-------------------------------------------------------------------------------
-- Parse a "#:" line that may contain *many*  path:lnum[:col]  chunks.
-- Returns the chunk under the cursor; if none, returns the first chunk.
-------------------------------------------------------------------------------
local function parse_reference(line, curcol)
  -- Strip the leading "#:" and surrounding white‑space
  local refs = line:gsub("^#:%s*", "")      -- e.g. "foo.py:10 bar.py:3"

  local default_path, default_lnum, default_col
  local best_path,    best_lnum,    best_col

  -- Iterate over each whitespace‑separated chunk
  local pos = 0
  for start_idx, token in refs:gmatch("()(%S+)") do
    local path, lnum, col = token:match("(.+):(%d+):?(%d*)$")
    if path then
      lnum = tonumber(lnum)
      col  = tonumber(col) or 1         -- default column = 1

      -- Remember the very first valid chunk as a fallback
      if not default_path then
        default_path, default_lnum, default_col = path, lnum, col
      end

      -- If the cursor is *within* this token, this is the best match
      local token_start = start_idx - 1          -- 0‑based like curcol
      local token_end   = token_start + #token
      if curcol >= token_start and curcol <= token_end then
        best_path, best_lnum, best_col = path, lnum, col
      end
    end
  end

  return best_path or default_path,
         best_lnum or default_lnum,
         best_col  or default_col
end

-------------------------------------------------------------------------------
-- Jump helper that never goes outside the buffer
-------------------------------------------------------------------------------
local function safe_edit(path, lnum, col)
  path = vim.fn.fnamemodify(path, ":p")                -- make absolute
  if vim.fn.filereadable(path) == 0 then
    return vim.notify("Cannot read file: " .. path, vim.log.levels.WARN)
  end

  vim.cmd("edit " .. vim.fn.fnameescape(path))

  local max = vim.api.nvim_buf_line_count(0)
  lnum = math.min(lnum, max)            -- clamp to buffer size
  col  = math.max(0, col - 1)           -- API is 0‑based

  vim.api.nvim_win_set_cursor(0, { lnum, col })
end

function M.jump_under_cursor()
  local row, curcol = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local path, lnum, col = parse_reference(line, curcol)

  if not path then
    return vim.notify("No reference on this line", vim.log.levels.INFO)
  end

  safe_edit(path, lnum, col)
end

-------------------------------------------------------------------------------
-- Public entry point: attach mapping when a *.po* buffer is opened
-------------------------------------------------------------------------------
function M.setup()
  vim.keymap.set(
    "n", "<C-]>", M.jump_under_cursor,
    { buffer = true, desc = "Jump to reference in source file" }
  )
end

return M
