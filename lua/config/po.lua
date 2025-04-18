-- in init.lua or any Lua plugin file
local group = vim.api.nvim_create_augroup('po-compiler', { clear = true })

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.po',
  group   = group,
  callback = function()
    -- load the compiler script we just created
    vim.cmd('compiler po')
  end,
})
