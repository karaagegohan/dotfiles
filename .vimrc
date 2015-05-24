" === Initialization ===================================================================================== {{{

scriptencoding utf-8

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" }}}

" === Shougo/neobundle.vim =============================================================================== {{{

call neobundle#begin(expand('~/.vim/bundle/'))

" managing plugins
NeoBundle 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc.vim', {
            \'build' : {
            \    'windows' : 'make -f make_mingw32.mak',
            \    'cygwin'  : 'make -f make_cygwin.mak ',
            \    'mac'     : 'make -f make_mac.mak    ',
            \    'unix'    : 'make -f make_unix.mak   ',
            \    },
            \}
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundleLazy 'Shougo/vimshell.vim', {
            \ 'depends' : [ 'Shougo/vimproc.vim' ]
            \ }
NeoBundle 'kana/vim-smartchr'            " insert several candidates with a single key
NeoBundle 'itchyny/lightline.vim'        " color command line
NeoBundle 'cohama/vim-hier'              " hilight quickfix errors
NeoBundle 'thinca/vim-quickrun'          " run current code quickly
NeoBundle 'thinca/vim-qfreplace'         " perform the replacement in quickfix
NeoBundle 'thinca/vim-visualstar'        " use * in visual mode
NeoBundle 'rhysd/clever-f.vim'           " improve f{char}
NeoBundle 'tomtom/tcomment_vim'          " comment out easily
NeoBundle 'junegunn/vim-easy-align'      " align codes by delimiter
NeoBundle 'fuenor/qfixgrep'              " make notes easily
NeoBundle 'fuenor/qfixhowm'              " make notes easily
NeoBundle 'tpope/vim-repeat'             " enable to repeat plugins by '.'
NeoBundle 'tpope/vim-fugitive'           " a Git wrapper
NeoBundle 'kien/rainbow_parentheses.vim' " better rainbow parentheses

" Unite
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'ujihisa/unite-font'
NeoBundle 'ujihisa/unite-help'

" Operator
NeoBundle 'kana/vim-operator-user'       " use vim-operator
NeoBundle 'tpope/vim-surround'           " surround text obj with any word
NeoBundle 'kana/vim-operator-replace'    " replace text obj with yanked word

" colorscheme
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'altercation/vim-colors-solarized'

" Java
NeoBundleLazy 'vim-scripts/javacomplete', {
            \   'build': {
            \       'cygwin': 'javac autoload/Reflection.java',
            \       'mac'   : 'javac autoload/Reflection.java',
            \       'unix'  : 'javac autoload/Reflection.java',
            \   },
            \}
NeoBundle 'moznion/java_getset.vim'

" Swift
" NeoBundle 'toyamarinyon/vim-swift'
NeoBundle 'keith/swift.vim'

call neobundle#end()

NeoBundleCheck
filetype plugin indent on

" }}}

" === Shougo/neocomplete.vim ============================================================================= {{{

let g:acp_enableAtStartup                           = 1         " Disable AutoComplPop.
let g:neocomplete#enable_at_startup                 = 1         " Use neocomplete.
let g:neocomplete#enable_smart_case                 = 1         " Use smartcase.
let g:neocomplete#sources#syntax#min_keyword_length = 1         " Set minimum syntax keyword length.
let g:neocomplete#lock_buffer_name_pattern          = '\*ku\*'  " file name to lock buffer

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Enable omni completion.
augroup vimrc_neocomplete
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

let g:neocomplete#force_overwrite_completefunc=1

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" }}}

" === Shougo/neosnippet ================================================================================== {{{

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif

" }}}

" === Shougo/unite.vim =================================================================================== {{{

let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200

" }}}

" === Shougo/unite-outline =============================================================================== {{{

let g:unite_split_rule = 'botright'

" }}}

" === itchyny/lightline.vim ============================================================================== {{{

let g:lightline = {
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'fugitive', 'filename' ] ]
            \ },
            \ 'component_function': {
            \   'fugitive': 'MyFugitive',
            \   'readonly': 'MyReadonly',
            \   'modified': 'MyModified',
            \   'filename': 'MyFilename'
            \ },
            \ }

function! MyModified()
    if &filetype == "help"
        return ""
    elseif &modified
        return "+"
    elseif &modifiable
        return ""
    else
        return ""
    endif
endfunction

function! MyReadonly()
    if &filetype == "help"
        return ""
    elseif &readonly
        return "RO"
    else
        return ""
    endif
endfunction

function! MyFugitive()
    return exists('*fugitive#head') ? fugitive#head() : ''
endfunction

function! MyFilename()
    return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
                \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
                \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

" }}}

" === junegunn/vim-easy-align ============================================================================ {{{

let g:easy_align_delimiters = {
            \ '"': {
            \     'pattern':         ' "',
            \     'delimiter_align': 'l',
            \     'left_margin':     2,
            \     'right_margin':    1
            \   },
            \ '.': {
            \     'pattern':         '+=\|=',
            \     'left_margin':   2,
            \     'right_margin':   0
            \   },
            \ }

" }}}

" === fuenor/qfixhowm ==================================================================================== {{{

let QFixHowm_Key                   = 'g'                                 " keymap of QFix first
let QFixHowm_KeyB                  = ','                                 " keymap of QFix second
let howm_dir                       = '~/Documents/Memo'                  " drectory to save memo
let howm_filename                  = '%Y/%m/%Y-%m-%d-%H%M%S.txt'         " filename
let howm_fileencoding              = 'utf-8'                             " character code
let howm_fileformat                = 'unix'                              " return code
let QFixHowmQFixHowm_Key_DiaryFile = 'diary/%Y/%m/%Y-%m-%d-000000.txt'   " filename of diary
let QFixHowm_MenuPreview           = 0                                   " preview in menz
let QFixHowm_MenuKey               = 0                                   " invalid default keymaps

" }}}

" === altercation/vim-colors-solarized =================================================================== {{{

" color
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

" }}}

" === moznion/java_getset.vim ============================================================================ {{{

let b:javagetset_enable_K_and_R = 1   " K$R style
let b:javagetset_add_this       = 1   " add .this

" }}}

" === basic settings ===================================================================================== {{{

" modeline
set modeline
set modelines       =3

" function
set history         =100                " number of history
set helplang        =ja                 " language to read help

" encoding
set encoding        =utf-8              " character code for .vimrc
set fileencoding    =utf-8              " character code to write files
set fileencodings   =utf-8,sjis         " character code to read file
set fileencodings  +=ucs-bom            " character code to read file
set fileencodings  +=iso-2022-jp-3      " character code to read file
set fileencodings  +=iso-2022-jp        " character code to read file
set fileencodings  +=eucjp-ms           " character code to read file
set fileencodings  +=euc-jisx0213       " character code to read file
set fileencodings  +=euc-jp             " character code to read file
set fileencodings  +=cp932              " character code to read file
set fileformats     =unix,dos,mac       " newline character

" view
syntax on                               " show syntax hilight
set number                              " show line number
set ruler                               " show current line number
set title                               " show title of the file
set showmatch                           " show matching bracket
set virtualedit    +=block              " expand bounds in visual mode
set nowrap                              " nowrap
set t_Co=256                            " 256 colors in vim

" indent
set backspace       =indent,eol,start   " more powerful backspacing
set smartindent                         " indent automatically
set autoindent                          " indent automatically
set shiftwidth      =4                  " width of indent for autoindent
set tabstop         =4                  " width of TAB
set expandtab                           " change TAB to space
set textwidth       =0                  " text width

" searching
set incsearch                           " disable increment search
set wrapscan                            " searchrs wrap around

" action
set autoread                            " reload file automatically when it is updated
set scrolloff       =20                 " scrooloff
set clipboard       =unnamed            " sharing clipboard

" fold
set foldenable                          " enable fold
set foldcolumn      =0                  " width of folding guide
set foldmethod      =marker             " folding by {{{.}}}

" directories
cd ~
set backup                              " make backup file
set backupdir       =~/vimFiles         " directiry to save backup files
set undofile                            " make undo file
set undodir         =~/vimFiles         " directiry to save undo files
set swapfile                            " make swap file
set directory       =~/vimFiles         " directiry to save swap files
set browsedir       =current            " directiry to save editing files

" colorscheme
colorscheme hybrid

" }}}

" === key mappings ======================================================================================= {{{

" ***NOTE*** {{{
" --------------------------------------------------------------------------------
" |      | normal    | insert    | command   | visual    | select    | waiting   |
" |------------------------------------------------------------------------------|
" |  map |     @     |     -     |     -     |     @     |     @     |     @     |
" | map! |     -     |     @     |     @     |     -     |     -     |     -     |
" | nmap |     @     |     -     |     -     |     -     |     -     |     -     |
" | imap |     -     |     @     |     -     |     -     |     -     |     -     |
" | cmap |     -     |     -     |     @     |     -     |     -     |     -     |
" | vmap |     -     |     -     |     -     |     @     |     @     |     -     |
" | xmap |     -     |     -     |     -     |     @     |     -     |     -     |
" | smap |     -     |     -     |     -     |     -     |     @     |     -     |
" | omap |     -     |     -     |     -     |     -     |     -     |     @     |
" --------------------------------------------------------------------------------
"
" ***NOTE***
" --------------------------------------------------------------------------------
" | -noremap: default key map (notreclusive)                                     |
" |     -map: plugins (reclusive)                                                |
" --------------------------------------------------------------------------------
"  }}}

" prefixes
nnoremap [prefix]           <Nop>
nmap     ,                  [prefix]
nnoremap [space]            <Nop>
nmap     <Space>            [space]

" basic mappimgs
noremap  ;                  :
noremap  :                  ;
noremap! ;                  :
noremap! :                  ;
noremap  <C-c>              <Esc>
nnoremap <silent><C-c><C-c> :<C-u>noh<CR>
nnoremap <CR>               :<C-u>w<CR>
nnoremap <BS>               :<C-u>q<CR>
nnoremap Q                  :<C-u>q!<CR>
nnoremap U                  <C-r>

" cursor
nnoremap j                  gj
nnoremap k                  gk
vnoremap j                  gj
vnoremap k                  gk
nnoremap H                  ^
vnoremap H                  ^
onoremap H                  ^
nnoremap J                  }
vnoremap J                  }
onoremap J                  }
nnoremap K                  {
vnoremap K                  {
onoremap K                  {
nnoremap L                  $
vnoremap L                  $
onoremap L                  $

" searching
nnoremap n                  nzz
nnoremap N                  Nzz

" window
nnoremap <C-h>              <C-w>h
nnoremap <C-j>              <C-w>j
nnoremap <C-k>              <C-w>k
nnoremap <C-l>              <C-w>l
nnoremap [space]n           :<C-u>split<CR>
nnoremap [space]v           :<C-u>vsplit<CR>

" tab
nnoremap <TAB>              gt
nnoremap <S-TAB>            gT
nnoremap <silent>[prefix]t  :<C-u>tabnew<CR>

" command mode
cnoremap <C-n>              <DOWN>
cnoremap <C-p>              <UP>

" fold
nnoremap z                  za

" vim-smartchr
inoremap <buffer><expr>=    smartchr#loop(' = ', ' == ', '=')

" handy
nnoremap <silent>[prefix].  :<C-u>e $MYVIMRC<CR>
nnoremap <silent>[prefix],  :<C-u>e $MYGVIMRC<CR>
nnoremap <silent>[prefix]r  :<C-u>source $MYVIMRC<CR>:<C-u>source $MYGVIMRC<CR>

" Unite
nnoremap [space]y           :<C-u>Unite history/yank<CR>
nnoremap [space]b           :<C-u>Unite buffer<CR>
nnoremap [space]f           :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap [space]r           :<C-u>Unite -buffer-name=register register<CR>
nnoremap [space]u           :<C-u>Unite file_mru buffer<CR>
nnoremap [space]f           :<C-u>Unite file<CR>

" QFixHowm
nmap     [space]m           g,m
nmap     [space]c           g,c
nmap     [space]q           g,q
nmap     [space],           g,,


" vimshell
nnoremap [space]is          :<C-u>VimShell<CR>
nnoremap [space]ip          :<C-u>VimShellInteractive python<CR>
nnoremap [space]ir          :<C-u>VimShellInteractive irb<CR>

" snippet
imap     <C-k>              <Plug>(neosnippet_expand_or_jump)
smap     <C-k>              <Plug>(neosnippet_expand_or_jump)

" operator
nmap     s                  <Plug>(operator-replace)

" comment out
nmap     \c                 <Plug>TComment_gcc<Esc>
vmap     \c                 <Plug>TComment_gcc<Esc>

" align
vmap     <Enter>            <Plug>(EasyAlign)

" Java
map      <buffer>[prefix]g  <Plug>JavagetsetInsertGetterOnly
map      <buffer>[prefix]s  <Plug>JavagetsetInsertSetterOnly
map      <buffer>[prefix]b  <Plug>JavagetsetInsertBothGetterSetter

" }}}

