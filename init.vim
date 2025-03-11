if &compatible
  set nocompatible
endif
filetype off
" append to runtime path
set rtp+=/usr/share/vim/vimfiles
set rtp+=/usr/bin/fzf

" Activate dein
let $CACHE = expand('~/.cache')
if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
  let s:dir = 'dein.vim'->fnamemodify(':p')
  if !(s:dir->isdirectory())
    let s:dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !(s:dir->isdirectory())
      execute '!git clone https://github.com/Shougo/dein.vim' s:dir
    endif
  endif
  execute 'set runtimepath^='
    \ .. s:dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endif

" initialize dein, plugins are installed to this directory
call dein#begin(expand('~/.cache/dein'))

" add packages here, e.g:
call dein#add('sainnhe/edge') " colorscheme
call dein#add('mhinz/vim-startify') " start screen

" Git
call dein#add('mhinz/vim-signify') " indicate changes in gitgutter

" airline tab
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')

" tools
call dein#add('scrooloose/nerdcommenter')
call dein#add('scrooloose/nerdtree')
call dein#add('ryanoasis/vim-devicons')
call dein#add('ctrlpvim/ctrlp.vim') " search by filename
call dein#add('junegunn/fzf.vim')
call dein#add('tpope/vim-surround')
call dein#add('tpope/vim-fugitive')
call dein#add('tell-k/vim-autopep8')

" general syntax
call dein#add('nvim-treesitter/nvim-treesitter', {'hook_post_update': 'TSUpdate'})
call dein#add('jiangmiao/auto-pairs')

" python
call dein#add('Glench/Vim-Jinja2-Syntax')

" css colors
call dein#add('norcalli/nvim-colorizer.lua')

" lsp
call dein#add('jose-elias-alvarez/null-ls.nvim')
call dein#add('neovim/nvim-lspconfig')
call dein#add('williamboman/mason.nvim')
call dein#add('williamboman/mason-lspconfig.nvim')
call dein#add('hrsh7th/nvim-cmp')
call dein#add('hrsh7th/cmp-nvim-lsp')
call dein#add('L3MON4D3/LuaSnip', #{ rev: 'v2.3' })
call dein#add('VonHeikemen/lsp-zero.nvim', #{ rev: 'v3.x' })

" snippets
call dein#add('saadparwaiz1/cmp_luasnip')
call dein#add('antonstakhouski/vim-react-snippets')

" harpoon
call dein#add('nvim-lua/plenary.nvim')
call dein#add('ThePrimeagen/harpoon', #{ rev: 'harpoon2' })

" GitHub Copilot
call dein#add('github/copilot.vim')

" exit dein
call dein#end()
" auto-install missing packages on startup
if dein#check_install()
  call dein#install()
endif

" default config
set number
set cursorline
set ignorecase
set nowrap
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable " Disable folding at startup.

" for colorizer
if exists('+termguicolors')
  let &termguicolors = 1
endif

" paste line at newline
nmap Y :yank<CR>
colorscheme edge

" load project level config
set exrc

" filetype settings
autocmd FileType javascript,javascriptreact,typescript,typescriptreact setlocal foldnestmax=1 textwidth=80 colorcolumn=80
autocmd FileType tex,css,scss,json,javascript,javascriptreact,typescript,typescriptreact,htmldjango,html,svg,vim setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab textwidth=79 colorcolumn=79
autocmd FileType po setlocal spell spelllang=ru_ru,en_us
autocmd FileType tex setlocal spell spelllang=en_us

" Highlight trailing spaces in red
highlight TrailingSpaces ctermbg=red guibg=red
match TrailingSpaces /\s\+$/

" plugins
map <F3> :NERDTreeToggle <CR>
let g:NERDTreeWinSize=50
" makes ctrlp faster somehow
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Airline (status line)
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1 " show opened buffers

" GitHub Copilot
let g:copilot_assume_mapped = 1
imap <M-Down> <Plug>(copilot-accept-line)
let g:AutoPairsMoveCharacter = ""

" Use tmux clipboard for copy/paste
vmap <C-c> :w !wl-copy<CR><CR>
nmap <C-v> :r !wl-paste<CR>

" providers
let g:python3_host_prog = '~/miniconda3/envs/nvim3/bin/python'
let g:node_host_prog = '~/miniconda3/envs/nvim3/bin/neovim-node-host'

" autopep8
" autopep brokes colorscheme, so we need to set it back
autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>:colorscheme edge<CR>
let g:autopep8_disable_show_diff=1

"lsp
lua <<EOF
  -- update .po files
  function RunFlaskCommandAsync()
    local command = 'conda activate issa_debug; export FLASK_APP=issa; flask translate update'
    vim.api.nvim_out_write('Translating files...\n')
    local job_id = vim.fn.jobstart(command, {
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          vim.api.nvim_out_write('Files translated successfully\n')
        else
          vim.api.nvim_out_write('Error translating files\n')
        end
      end,
    })
  end

  vim.api.nvim_set_keymap('n', '<F5>', '<cmd>lua RunFlaskCommandAsync()<CR>', { noremap = true, silent = true })

  local lsp_zero = require('lsp-zero')

  lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({
      buffer = bufnr,
    })
  end)

  -- see :help lsp-zero-guide:integrate-with-mason-nvim
  -- to learn how to use mason.nvim with lsp-zero
  require('mason').setup({})
  require('mason-lspconfig').setup({
    handlers = {
      lsp_zero.default_setup,
    }
  })

  local null_ls = require('null-ls')

  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.prettierd,
    },
  })

  local lspconfig = require('lspconfig')

  -- Setup eslint-lsp
  lspconfig.eslint.setup {
    -- Custom function to set the root directory
    root_dir = function(fname)
      return lspconfig.util.root_pattern('app/static/eslint.config.mjs')(fname)
          or lspconfig.util.root_pattern('.git')(fname)
          or lspconfig.util.path.dirname(fname)
    end,
    settings = {
      workingDirectory = { mode = 'location' }, -- Use the config file's location
    },
    filetypes = { "scss", "javascript", "typescript" }, -- Add SCSS to the list of filetypes
    on_attach = function(client, bufnr)
      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  }

  -- Enable colorizer
  require('colorizer').setup({ '*'; }, { RRGGBBAA = true; })

  local cmp = require('cmp')
  local cmp_action = require('lsp-zero').cmp_action()
  local cmp_format = require('lsp-zero').cmp_format()

  require('luasnip.loaders.from_vscode').lazy_load()

  cmp.setup({
    sources = {
      {name = 'nvim_lsp'},
      {name = 'luasnip'},
    },
    mapping = cmp.mapping.preset.insert({
      ['<TAB>'] = cmp.mapping.select_next_item(), -- use TAB to switch completion items
      ['<CR>'] = cmp.mapping.confirm({select = false}), -- use CR to complete (for snippets)
    }),
    --- (Optional) Show source name in completion menu
    formatting = cmp_format,
    snippet = {
      expand = function(args)
        require'luasnip'.lsp_expand(args.body)
      end
    },
  })

  -- treesitter config
  require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

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

  -- harpoon config
  local harpoon = require("harpoon")

  -- REQUIRED
  harpoon:setup()
  -- REQUIRED

  vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
  vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

  vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
  vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
  vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
  vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
EOF
