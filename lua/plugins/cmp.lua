return {
  {
    "hrsh7th/nvim-cmp",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "VonHeikemen/lsp-zero.nvim",
      "onsails/lspkind.nvim",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "mlaursen/vim-react-snippets",
    },
    config = function()
      require("vim-react-snippets").lazy_load()

      -- if you do not want to wrap all props in `Readonly<T>`
      local config = require("vim-react-snippets.config")
      config.readonly_props = false

      local cmp = require('cmp')
      local cmp_action = require('lsp-zero').cmp_action()
      local cmp_format = require('lsp-zero').cmp_format()

      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
      end

      local lspkind = require('lspkind')

      -- luasnip setup
      local ls = require("luasnip")

      vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

      vim.keymap.set({"i", "s"}, "<C-E>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, {silent = true})

      -- cmp setup
      cmp.setup({
        sources = {
          {name = 'copilot'},
          {name = 'nvim_lsp'},
          {name = 'luasnip'},
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end),
          ['<CR>'] = cmp.mapping.confirm({select = false}), -- use CR to complete (for snippets)
        }),
        --- (Optional) Show source name in completion menu
        formatting =  {
          format = lspkind.cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = {
              -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
              -- can also be a function to dynamically calculate max width such as
              -- menu = function() return math.floor(0.45 * vim.o.columns) end,
              menu = 50, -- leading text (labelDetails)
              abbr = 50, -- actual suggestion item
            },
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default
            symbol_map = { Copilot = "" }
          })
        },
        snippet = {
          expand = function(args)
            require'luasnip'.lsp_expand(args.body)
          end
        },
      })
    end,
  },
}
