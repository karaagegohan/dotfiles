" === Shougo/neobundle.vim =============================================================================== {{{

scriptencoding utf-8
augroup vimrc
    autocmd!
augroup END

if !isdirectory('~/vimFiles')
    call mkdir('~/vimFiles', 'p')
endif

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc.vim', {
            \ 'build' : {
            \ 'windows' : 'make -f make_mingw32.mak',
            \ 'cygwin'  : 'make -f make_cygwin.mak ',
            \ 'mac'     : 'make -f make_mac.mak    ',
            \ 'unix'    : 'make -f make_unix.mak   ',
            \ },
            \ }
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/unite-outline'
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
NeoBundle 'kana/vim-operator-user'       " use vim-operator
NeoBundle 'rhysd/vim-operator-surround'  " surround text obj with any word
NeoBundle 'kana/vim-operator-replace'    " replace text obj with yanked word
NeoBundle 'tomtom/tcomment_vim'          " comment out easily
NeoBundle 'junegunn/vim-easy-align'      " align codes by delimiter
NeoBundle 'fuenor/qfixgrep'              " make notes easily
NeoBundle 'fuenor/qfixhowm'              " make notes easily
NeoBundle 'tpope/vim-repeat'             " enable to repeat plugins by '.'
NeoBundle 'tpope/vim-fugitive'           " a Git wrapper

NeoBundle 'w0ng/vim-hybrid' " colorscheme

filetype plugin on
filetype indent on
NeoBundleCheck

call neobundle#end()

" ======================================================================================================== }}}

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
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

let g:neocomplete#force_overwrite_completefunc=1

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" ======================================================================================================== }}}

" === Shougo/neosnippet ================================================================================== {{{

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif

" ======================================================================================================== }}}

" === Shougo/unite.vim =================================================================================== {{{

let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200

" ======================================================================================================== }}}

" === Shougo/unite-outline =============================================================================== {{{

let g:unite_split_rule = 'botright'
noremap [space]o <ESC>:Unite -vertical -winwidth=60 outline<Return>

" ======================================================================================================== }}}

" === Shougo/vimshell ==================================================================================== {{{

" ======================================================================================================== }}}

" === kana/vim-smartchr ================================================================================== {{{

inoremap <buffer> <expr> = smartchr#loop(' = ', ' == ', '=')

" ======================================================================================================== }}}

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

" ======================================================================================================== }}}

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

" ======================================================================================================== }}}

" === fuenor/qfixhowm ==================================================================================== {{{

let QFixHowm_Key       = 'g'  " keymap of QFix
let QFixHowm_KeyB      = ','  " keymap of QFix
let howm_dir           = '~/Documents/Memo'
let howm_filename      = '%Y/%m/%Y-%m-%d-%H%M%S.txt'
let howm_fileencoding  = 'utf-8'
let howm_fileformat    = 'unix'
let QFixHowmQFixHowm_Key_DiaryFile = 'diary/%Y/%m/%Y-%m-%d-000000.txt'

" ======================================================================================================== }}}

" === tpope/vim-fugitive ================================================================================= {{{

" ======================================================================================================== }}}

" === basic settings ===================================================================================== {{{

" modeline
set modeline
set modelines       =3

" function
set history         =100                " number of history
set helplang        =en                 " language to read help

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

" show
set number                              " show line number
set ruler                               " show current line number
set title                               " show title of the file
syntax on                               " show syntax hilight
set showmatch                           " show matching bracket
set virtualedit    +=block              " expand bounds in visual mode

" indent
set backspace       =indent,eol,start   " more powerful backspacing
set smartindent                         " indent automatically
set autoindent                          " indent automatically
set shiftwidth      =4                  " width of indent for autoindent
set tabstop         =4                  " width of TAB
set expandtab                           " change TAB to space

" searching
set incsearch                           " disable increment search
set hlsearch                            " hililight result
set wrapscan                            " searchrs wrap around

" action
set autoread                            " reload file automatically when it is updated
set scrolloff       =15                 " scrooloff
set foldmethod      =marker             " folding {{{.}}}
set clipboard       =unnamed            " sharing clipboard

" directories
cd ~
set backup
set backupdir       =~/vimFiles         " directiry to save backup files
set undofile                            " make undo file
set undodir         =~/vimFiles         " directiry to save undo files
set swapfile                            " make swap file
set directory       =~/vimFiles         " directiry to save swap files
set browsedir       =current            " directiry to save editing files

" ======================================================================================================== }}}

" === key mappings ======================================================================================= {{{

" basic mappimgs
nnoremap ;                  :
vnoremap ;                  :
noremap  <C-c>              <Esc>
nnoremap <silent><C-c><C-c> :<C-u>noh<CR>
nnoremap <CR>               :<C-u>w<CR>
nnoremap <BS>               :<C-u>q<CR>
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

cnoremap <C-j>              <DOWN>
cnoremap <C-k>              <UP>

" fold
nnoremap z                  za

" window
nnoremap <C-h>              <C-w>h
nnoremap <C-j>              <C-w>j
nnoremap <C-k>              <C-w>k
nnoremap <C-l>              <C-w>l

" handy
nnoremap [prefix]           <Nop>
nmap     ,                  [prefix]
nnoremap <silent>[prefix]v  :<C-u>vnew<CR>
nnoremap <silent>[prefix]n  :<C-u>new<CR>
nnoremap <silent>[prefix].  :<C-u>e $MYVIMRC<CR>
nnoremap <silent>[prefix],  :<C-u>e $MYGVIMRC<CR>
nnoremap <silent>[prefix]r  :<C-u>source $MYVIMRC<CR>:<C-u>source $MYGVIMRC<CR>
nnoremap <silent>[prefix]w  :<C-u>w<CR>
nnoremap <silent>[prefix]W  :<C-u>W<CR>
nnoremap <silent>[prefix]q  :<C-u>q<CR>
nnoremap <silent>[prefix]Q  :<C-u>Q<CR>
nmap     <silent>[prefix]m  g,m
nmap     <silent>[prefix]c  g,c

" Unite and vimshell
nnoremap [space]            <Nop>
nmap     <Space>            [space]
nnoremap <silent>[space]y   :<C-u>Unite history/yank<CR>
nnoremap <silent>[space]b   :<C-u>Unite buffer<CR>
nnoremap <silent>[space]f   :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent>[space]r   :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent>[space]u   :<C-u>Unite file_mru buffer<CR>
nnoremap <silent>[space]is  :<C-u>VimShell<CR>
nnoremap <silent>[space]ip  :<C-u>VimShellInteractive python<CR>
nnoremap <silent>[space]ir  :<C-u>VimShellInteractive irb<CR>

" complete and snippet
imap     <C-k>              <Plug>(neosnippet_expand_or_jump)
smap     <C-k>              <Plug>(neosnippet_expand_or_jump)

" operator
nmap     ys                 <Plug>(operator-surround-append)
nmap     ds                 <Plug>(operator-surround-delete)
nmap     cs                 <Plug>(operator-surround-replace)
nmap     s                  <Plug>(operator-replace)

" comment out
nmap     \c                 <Plug>TComment_gcc<Esc>
vmap     \c                 <Plug>TComment_gcc<Esc>

" align
vmap     <Enter>            <Plug>(EasyAlign)

" ======================================================================================================== }}}

