if &compatible
  set nocompatible
endif
filetype off
" append to runtime path
set rtp+=/usr/share/vim/vimfiles
set rtp+=/usr/bin/fzf

" Activatedein
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
call dein#add('sainnhe/edge')
call dein#add('mhinz/vim-startify') " start screen

" Git
call dein#add('mhinz/vim-signify')
call dein#add('tpope/vim-fugitive')

" airline tab
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')

" run tasks in background
call dein#add('tpope/vim-dispatch')
call dein#add('radenling/vim-dispatch-neovim')
call dein#add('ctrlpvim/ctrlp.vim') " search by filename

" ui
call dein#add('scrooloose/nerdcommenter')
call dein#add('scrooloose/nerdtree')
call dein#add('ap/vim-buftabline')

" lsp
call dein#add('neovim/nvim-lspconfig')
call dein#add('williamboman/mason.nvim')
call dein#add('williamboman/mason-lspconfig.nvim')
call dein#add('hrsh7th/nvim-cmp')
call dein#add('hrsh7th/cmp-nvim-lsp')
call dein#add('L3MON4D3/LuaSnip')
call dein#add('VonHeikemen/lsp-zero.nvim', #{ rev: 'v3.x' })

" snippets
" call dein#add('antonstakhouski/vim-react-snippets')
call dein#add('afamadriz/friendly-snippets')

" general syntax
call dein#add('AndrewRadev/splitjoin.vim')
call dein#add('luochen1990/rainbow')
call dein#add('jiangmiao/auto-pairs')
call dein#add('tpope/vim-surround')
call dein#add('junegunn/fzf.vim')
call dein#add('ntpeters/vim-better-whitespace')

" Web
call dein#add('tell-k/vim-autopep8')
" call dein#add('ap/vim-css-color') " TODO conflicts with JSX
call dein#add('prettier/vim-prettier')

" C++
" call dein#add('rhysd/vim-clang-format')
" exit dein
call dein#end()
" auto-install missing packages on startup
if dein#check_install()
  call dein#install()
endif
filetype plugin on
filetype plugin indent on

set shell=/bin/bash

set number
set visualbell

noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

" c-j c-k for moving in snippet
let g:UltiSnipsExpandTrigger		= "<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger	= "<c-j>"
let g:UltiSnipsJumpBackwardTrigger	= "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0

map <F3> :NERDTreeToggle <CR>
map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
map <F5> :Dispatch <CR>
map <F6> :call FindProjectRoot(expand('%:p:h')) <CR>
autocmd FileType python noremap <buffer> <F8> :call Autopep8() <CR><Paste>
autocmd FileType javascript,typescript,less,scss,css,json,graphql,markdown noremap <F8> :Prettier <CR><Paste>
map <F10> :ClangFormat <CR>
nmap Y :yank<CR>

autocmd FileType python let b:dispatch = 'python -m unittest'

let g:python3_host_prog = '~/miniconda3/envs/nvim3/bin/python'
let g:node_host_prog = '~/miniconda3/envs/nvim3/bin/neovim-node-host'

" fzf
let g:fzf_layout = { 'down': '~40%' }

colorscheme edge

autocmd FileType cpp,h setlocal expandtab smartindent autoindent tabstop=4 shiftwidth=4

set completeopt=noinsert,menuone,noselect

let g:AutoPairsMapCR = 0

set noshowmode

" ctrl-P
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" NERDcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

set clipboard+=unnamedplus

set cursorline

set hlsearch

" set UTF-8 encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
set encoding=utf-8

set autoindent
set smartindent
set ignorecase
set smartcase


set nobackup
set nowritebackup
set noswapfile

set history=100

set ruler

set incsearch

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
" wrap lines at 120 chars. 80 is somewaht antiquated with nowadays displays.
set textwidth=120
set colorcolumn=120
" turn syntax highlighting on
syntax on
set nowrap
" highlight matching braces
set showmatch
set backspace=indent,eol,start

if !exists('g:dispatch_compilers')
  let g:dispatch_compilers = {}
endif
let g:dispatch_compilers['ssh a.stahovski@10.60.61.54'] = ''

fun! BuildLocalTarget(path)
  :execute 'Dispatch make -j20 -C' a:path
endfun

fun! BuildRemoteTarget(path)
  let rel_path = substitute(a:path, $HOME.'/', '', '')
  :execute 'Dispatch ssh a.stahovski@10.60.61.54  make  -j6 -C' rel_path
endfun

fun! FindProjectRoot(path)
  let full_path = fnamemodify(a:path, ':p:h')
  if full_path == '/'
    return
  elseif filereadable(a:path."/Makefile")
    if full_path =~ 'switch_rt'
      :call BuildRemoteTarget(full_path)
    else
      :call BuildLocalTarget(full_path)
    endif
    return
  else
    :call FindProjectRoot(full_path."/../")
  endif
endfun


autocmd BufWinEnter * highlight ColorColumn ctermbg=DarkGrey

" Airline (status line)
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

set hidden

" jump to last cursor
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

fun! StripTrailingWhitespace()
  " don't strip on these filetypes
  if &ft =~ 'markdown'
    return
  endif
  %s/\s\+$//e
endfun
"autocmd BufWritePre * call StripTrailingWhitespace()

" file formats
autocmd Filetype gitcommit setlocal spell textwidth=72
autocmd Filetype markdown setlocal wrap linebreak nolist textwidth=0 wrapmargin=0 " http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
autocmd FileType sh,cucumber,ruby,yaml,zsh,vim setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab autoindent textwidth=79 colorcolumn=79
autocmd FileType html,css,scss,jinja.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType json setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab autoindent
autocmd FileType po setlocal spell spelllang=ru_ru,en_us
autocmd FileType javascript,javascriptreact setlocal foldmethod=syntax foldnestmax=1 tabstop=2 shiftwidth=2 softtabstop=2 expandtab autoindent textwidth=109 colorcolumn=109

let g:vim_jsx_pretty_colorful_config = 1
let g:deoplete#enable_at_startup = 1

let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

autocmd Bufread,BufNewFile *.md set filetype=markdown " Vim interprets .md as 'modula2' otherwise, see :set filetype?
autocmd BufRead,BufNewFile *.html set syntax=jinja.html

" Change colourscheme when diffing
fun! SetDiffColors()
  highlight DiffAdd    cterm=bold ctermfg=white ctermbg=DarkGreen
  highlight DiffDelete cterm=bold ctermfg=white ctermbg=DarkGrey
  highlight DiffChange cterm=bold ctermfg=white ctermbg=DarkBlue
  highlight DiffText   cterm=bold ctermfg=white ctermbg=DarkRed
endfun
autocmd FilterWritePre * call SetDiffColors()

"lsp
lua <<EOF
  local lsp_zero = require('lsp-zero')

  lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({
      buffer = bufnr,
      preserve_mappings = false
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

  require('luasnip.loaders.from_vscode').lazy_load()

  cmp.setup({
    sources = {
      {name = 'nvim_lsp'},
      {name = 'luasnip'},
    },
    mapping = cmp.mapping.preset.insert({
      ['<TAB>'] = cmp.mapping.select_next_item()
    }),
  })
EOF
