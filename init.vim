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
call dein#add('ctrlpvim/ctrlp.vim') " search by filename
call dein#add('junegunn/fzf.vim')

" lsp
call dein#add('neovim/nvim-lspconfig')
call dein#add('williamboman/mason.nvim')
call dein#add('williamboman/mason-lspconfig.nvim')
call dein#add('hrsh7th/nvim-cmp')
call dein#add('hrsh7th/cmp-nvim-lsp')
call dein#add('L3MON4D3/LuaSnip')
call dein#add('VonHeikemen/lsp-zero.nvim', #{ rev: 'v3.x' })

" exit dein
call dein#end()
" auto-install missing packages on startup
if dein#check_install()
  call dein#install()
endif

" default config
set number
colorscheme edge

" filetype settings
autocmd FileType javascript,javascriptreact setlocal foldmethod=syntax foldnestmax=1 tabstop=2 shiftwidth=2 softtabstop=2 expandtab autoindent textwidth=109 colorcolumn=109

" plugins
map <F3> :NERDTreeToggle <CR>
" makes ctrlp faster somehow
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Airline (status line)
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1 " show opened buffers

"lsp
lua <<EOF
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

  local cmp = require('cmp')
  local cmp_action = require('lsp-zero').cmp_action()

  cmp.setup({
    sources = {
      {name = 'nvim_lsp'},
      {name = 'luasnip'},
    },
    mapping = cmp.mapping.preset.insert({
      ['<TAB>'] = cmp.mapping.select_next_item() -- use TAB to switch completion items
    }),
  })
EOF
