local M = {}

-------------------------------------------------------------------------------
-- Parse "#: path/to/file:123:4" →  path , 123 , 4
-------------------------------------------------------------------------------
local function parse_reference(line)
  -- greedy up to last ':' so paths like "foo:bar/baz.py:10" still work
  local path, lnum, col = line:match("^#:%s+(.-):(%d+):?(%d*)$")
  if not path then return end
  return path,
         tonumber(lnum),
         tonumber(col) or 1      -- default column = 1
end

-------------------------------------------------------------------------------
-- Jump helper that never goes outside the buffer
-------------------------------------------------------------------------------
local function safe_edit(path, lnum, col)
  vim.cmd("edit " .. vim.fn.fnameescape(path))

  local max = vim.api.nvim_buf_line_count(0)
  lnum = math.min(lnum, max)     -- clamp   1‑based
  col  = math.max(0, col - 1)    -- 0‑based for API

  vim.api.nvim_win_set_cursor(0, { lnum, col })
end

function M.jump_under_cursor()
  local row  = vim.api.nvim_win_get_cursor(0)[1] - 1
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]
  local path, lnum, col = parse_reference(line)

  if not path then
    return vim.notify("No reference on this line", vim.log.levels.INFO)
  end

  if vim.fn.filereadable(path) == 0 then
    return vim.notify("Cannot read file: " .. path, vim.log.levels.WARN)
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
