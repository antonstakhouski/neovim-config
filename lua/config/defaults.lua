-- Default editor config
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.wrap = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- disable folding at startup

-- Clipboard integration with tmux (wayland)
vim.keymap.set("v", "<C-c>", [[:w !wl-copy<CR><CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "<C-v>", [[:r !wl-paste<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "Y", ":yank<CR>", { noremap = true, silent = true })

-- Python & Node provider paths
vim.g.python3_host_prog = vim.fn.expand("~/miniconda3/envs/nvim3/bin/python")
vim.g.node_host_prog = vim.fn.expand("~/miniconda3/envs/nvim3/bin/neovim-node-host")

-- Show diagnostics in the same line
vim.diagnostic.config({ virtual_text = true })

-- Show round border around floating windows
vim.o.winborder = 'rounded'

-- somewhere early in your init.lua
if vim.filetype then
  vim.filetype.add({
    extension = { html = "html" },   -- *.html  → "html"
    -- (you can also add `filename = { … }` or `pattern = { … }` here)
  })
end
