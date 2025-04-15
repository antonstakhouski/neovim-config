-- Default editor config
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.wrap = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- disable folding at startup

-- Highlight trailing spaces
vim.cmd([[highlight TrailingSpaces ctermbg=red guibg=red]])
vim.cmd([[match TrailingSpaces /\s\+$/]])

-- Clipboard integration with tmux (wayland)
vim.keymap.set("v", "<C-c>", [[:w !wl-copy<CR><CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "<C-v>", [[:r !wl-paste<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "Y", ":yank<CR>", { noremap = true, silent = true })

-- Python & Node provider paths
vim.g.python3_host_prog = vim.fn.expand("~/miniconda3/envs/nvim3/bin/python")
vim.g.node_host_prog = vim.fn.expand("~/miniconda3/envs/nvim3/bin/neovim-node-host")

-- Autopep8
vim.g.autopep8_disable_show_diff = 1
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.keymap.set("n", "<F8>", function()
      vim.cmd("call Autopep8()")         -- run autopep8
    end, { buffer = true, noremap = true, silent = true })
  end,
})
