return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = { "lua", "javascript", "typescript", "python" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        -- List of parsers to ignore installing (or "all")
        ignore_install = { },

        -- Experimental
        indent = {
          enable = true
        },

        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

        highlight = {
          enable = true,

          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          -- list of language that will be disabled
          disable = { "tex" },
          -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  },
  -- TODO: works not very good
  {
    "HiPhish/jinja.vim",
    config = function()
      local autocmd = vim.api.nvim_create_autocmd
      local augroup = vim.api.nvim_create_augroup

      -- Adjust filetype on *.html for Jinja
      autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.html",
        callback = function()
          vim.fn["jinja#AdjustFiletype"]()
        end,
      })

      -- One-time setup to handle missing Treesitter parser for jinja
      autocmd("FileType", {
        group = augroup("JinjaSyntaxFix", { clear = true }),
        callback = function(args)
          if vim.b.jinja_syntax_autocmd_loaded then return end

          local has_treesitter = vim.treesitter.language.get_lang("jinja") ~= nil

          if not has_treesitter and vim.bo[args.buf].filetype ~= "" then
            vim.bo[args.buf].syntax = "on"
          end

          vim.b.jinja_syntax_autocmd_loaded = true
        end,
      })
    end,
  },
}
