return {
  -- the colorscheme should be available when starting Neovim
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- Start screen
  {
    'nvimdev/dashboard-nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {}
    end,
  },

  -- Syntax & Treesitter
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- CSS Colorizer
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require('colorizer').setup({ '*'; }, { RRGGBBAA = true; })
    end,
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    version = "v3.x",
    lazy = false, -- ensure it loads before others
    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
      end)
    end,
  },
}
