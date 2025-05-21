vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function()
    vim.opt_local.foldnestmax = 1
    vim.opt_local.textwidth = 80
    vim.opt_local.colorcolumn = "80"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "tex", "css", "scss", "json", "lua",
    "javascript", "javascriptreact",
    "typescript", "typescriptreact",
    "htmldjango", "jinja", "html", "svg", "vim"
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
    vim.opt_local.textwidth = 88
    vim.opt_local.colorcolumn = "88"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "po",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "ru_ru,en_us"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
  end,
})
