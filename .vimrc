"/ === Initialization =================================================================================== {{{

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" }}}

" === key_mappings ======================================================================================= {{{

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
" | -noremap: default key map (notreclusive)                                     |
" |     -map: plugins etc. (reclusive)                                           |
" --------------------------------------------------------------------------------
"  }}}

" prefixes
nnoremap [bpref]            <Nop>
nmap     ,                  [bpref]
nnoremap [fpref]            <Nop>
nmap     <Space>            [fpref]

" base mappimgs
noremap  ;                  :
noremap  :                  ;
noremap! ;                  :
noremap! :                  ;
noremap  <C-c>              <Esc>
nnoremap <silent><C-c><C-c> :<C-u>noh<CR>
nnoremap <silent><CR>       :<C-u>write<CR>
nnoremap <BS>               :<C-u>quit<CR>
nnoremap U                  <C-r>
nnoremap ZZ                 <Nop>
nnoremap ZQ                 <Nop>

" yank
nnoremap Y yW

" cursor
nnoremap j                  gj
nnoremap k                  gk
nnoremap k                  gk
nnoremap k                  gk
vnoremap j                  gj
vnoremap k                  gk
noremap  H                  ^
noremap  J                  }
noremap  K                  {
noremap  L                  $

" searching
nnoremap n                  nzO
nnoremap N                  NzO
nnoremap *                  *NzO
nnoremap #                  #NzO

" window
nnoremap <C-h>              <C-w>h
nnoremap <C-j>              <C-w>j
nnoremap <C-k>              <C-w>k
nnoremap <C-l>              <C-w>l
nnoremap <silent>[bpref]n   :<C-u>split<CR>
nnoremap <silent>[bpref]v   :<C-u>vsplit<CR>

" tab
nnoremap <TAB>              gt
nnoremap <S-TAB>            gT
nnoremap [bpref]t           :<C-u>tabnew<CR>

" command mode
cnoremap <C-n>              <DOWN>
cnoremap <C-p>              <UP>

" fold
nnoremap z                  za

" handy
nnoremap <silent>[bpref].   :<C-u>edit ~/dotfiles/.vimrc<CR>
nnoremap <silent>[bpref],   :<C-u>edit ~/dotfiles/.gvimrc<CR>
nnoremap <silent>[bpref]r   :<C-u>source $MYVIMRC<CR>:<C-u>source $MYGVIMRC<CR>
nnoremap <silent>[bpref]km  /key_mappings<CR>zo 

" }}}

" === Shougo/neobundle.vim =============================================================================== {{{

" ***NOTE*** {{{
"
" NeoBundleLazy
"     autoload
"         filetypes
"         commands
"         function_prefix
"         mappings
"         isert
"     depends
"
"  }}}

filetype plugin indent off

call neobundle#begin(expand('~/.vim/bundle/'))

" managing plugins
NeoBundle 'Shougo/neobundle.vim'

" great asynchronous execution
NeoBundle 'Shougo/vimproc.vim', {
            \'build' : {
            \    'windows' : 'make -f make_mingw32.mak',
            \    'cygwin'  : 'make -f make_cygwin.mak ',
            \    'mac'     : 'make -f make_mac.mak    ',
            \    'unix'    : 'make -f make_unix.mak   ',
            \    },
            \}

" complement 
NeoBundle has('lua') ? 'Shougo/neocomplete.vim' : 'Shougo/neocomplcache.vim' 
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'karaagegohan/my-snippets'

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
NeoBundle 'LeafCage/yankround.vim'       " paste yank history
NeoBundle 'Lokaltog/vim-easymotion'      " powerful motion

" syntax
" NeoBundle 'scrooloose/syntastic.git'     " powerful syntax

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

" Java 
NeoBundleLazy 'vim-scripts/javacomplete', {
            \   'build': {
            \       'cygwin': 'javac autoload/Reflection.java',
            \       'mac'   : 'javac autoload/Reflection.java',
            \       'unix'  : 'javac autoload/Reflection.java',
            \   },
            \   'autoload': {
            \       'filetypes': ['java'],
            \   },
            \} 
NeoBundleLazy 'moznion/java_getset.vim', {
            \   'autoload': {
            \       'filetypes': ['java'],
            \   },
            \}

" Swift 
NeoBundleLazy 'keith/swift.vim', {
            \   'autoload': {
            \       'filetypes': ['swift'],
            \   },
            \}

" colorscheme 
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'morhetz/gruvbox'

"dictionary
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/excitetranslate-vim'

call neobundle#end()

NeoBundleCheck
NeoBundleClean

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
    autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

let g:neocomplete#force_overwrite_completefunc=1

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c   = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" }}}

" === Shougo/neocomplcache.vim =========================================================================== {{{

" TODO

" }}}

" === Shougo/neosnippet ================================================================================== {{{

" key_mappings {{{
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
" }}}

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 
    set concealcursor=i
endif

" other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/my-snippets/snippets'

" }}}

" === tpope/vim-fugitive ================================================================================= {{{

" key_mappings {{{
" prefix
nnoremap [git]    <Nop>
nmap     [fpref]g [git]

nnoremap [git]a  :<C-u>Gwrite<CR>
nnoremap [git]d  :<C-u>Gdiff<CR>
nnoremap [git]c  :<C-u>Gcommit -m ''<LEFT>
nnoremap [git]ps :<C-u>Git push origin master<CR>
nnoremap [git]pl :<C-u>Git pull<CR>
nnoremap [git]st :<C-u>Git status<CR>
nnoremap [git]sh :<C-u>Git stash<CR>
" }}}

" }}}

" === kana/vim-smartchr ================================================================================== {{{

augroup vim_schar
    autocmd!
    autocmd FileType swift inoremap <buffer><expr>- smartchr#loop('-', ' -> ')
augroup END
inoremap <buffer><expr>= smartchr#loop(' = ', ' == ', '=')

" }}}

" === Shougo/vimshell.vim ================================================================================ {{{

" key_mappings {{{
" prefix
nnoremap [shell]  <Nop>
nmap     [fpref]s    [shell]

nnoremap [shell]s :<C-u>VimShellPop<CR>
nnoremap [shell]p :<C-u>VimShellInteractive python<CR>
nnoremap [shell]r :<C-u>VimShellInteractive irb<CR>
" }}}

" }}}

" === Shougo/unite.vim =================================================================================== {{{

let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200

" key_mappings {{{
" prefix
nnoremap [unite]   <Nop>
nmap     [fpref]u  [unite]

nnoremap [unite]u  :<C-u>Unite<CR>
nnoremap [unite]hy :<C-u>Unite history/yank<CR>
nnoremap [unite]hf :<C-u>Unite file_mru buffer<CR>
nnoremap [unite]b  :<C-u>Unite buffer<CR>
nnoremap [unite]r  :<C-u>Unite -buffer-name=register register<CR>
nnoremap [unite]f  :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" }}}

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

if isdirectory(expand('~/Google\ Drive'))
    if !isdirectory(expand('~/Google\ Drive/Memo'))
        call mkdir('~/Google\ Drive/Memo', 'p')
    endif
    let howm_dir                   = '~/Google\ Drive/Memo'              " directory
    let QFixMRU_Filename           = '~/Google\ Drive/Memo/.qfixmru'     " MRU file
endif

let QFixHowmQFixHowm_Key_DiaryFile = 'diary/%Y/%m/%Y-%m-%d-000000.txt'   " filename of diary
let QFixHowm_Key                   = 'g'                                 " keymap of QFix first
let QFixHowm_KeyB                  = ','                                 " keymap of QFix second
let howm_filename                  = '%Y/%m/%Y-%m-%d-%H%M%S.txt'         " filename
let howm_fileencoding              = 'utf-8'                             " character code
let howm_fileformat                = 'unix'                              " return code
let QFixHowm_MenuPreview           = 0                                   " preview in menu
let QFixHowm_MenuKey               = 0                                   " invalid default keymaps

" QFixHowm
nmap     [fpref]m           g,m
nmap     [fpref]c           g,c
nmap     [fpref]q           g,q
nmap     [fpref],           g,,

" }}}

" === kien/rainbow_parentheses.vim ======================================================================= {{{

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

let g:rbpt_max            = 16
let g:rbpt_loadcmd_toggle = 0

" }}}

" === moznion/java_getset.vim ============================================================================ {{{

let b:javagetset_enable_K_and_R = 1   " K$R style
let b:javagetset_add_this       = 1   " add .this

" key_mappings {{{
map <buffer>[bpref]g <Plug>JavagetsetInsertGetterOnly
map <buffer>[bpref]s <Plug>JavagetsetInsertSetterOnly
map <buffer>[bpref]b <Plug>JavagetsetInsertBothGetterSetter
" }}}

" }}}

" === scrooloose/syntastic.git =========================================================================== {{{

let g:syntastic_enable_signs  = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_mode_map = {'mode': 'passive'} 

augroup AutoSyntastic
    autocmd!
    autocmd InsertLeave,TextChanged * call s:syntastic() 
augroup END

function! s:syntastic()
    " w
    " SyntasticCheck
endfunction

" }}}

" === LeafCage/yankround.vim ============================================================================= {{{

let g:yankround_max_history = 100

" key_mappings {{{
nmap p     <Plug>(yankround-p)
nmap P     <Plug>(yankround-P)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)
" }}}

" }}}

" === Lokaltog/vim-easymotion ============================================================================ {{{
let g:EasyMotion_keys       = 'hjklasdfgyuiopqwertnmzxcvbHJKLASDFGYUIOPQWERTNMZXCVB'
let g:EasyMotion_grouping   = 1

" key_mappings {{{
map m <Plug>(easymotion-prefix)
map f <Plug>(easymotion-fl)
map t <Plug>(easymotion-tl)
map F <Plug>(easymotion-Fl)
map T <Plug>(easymotion-Tl)
" }}}

" }}}

" === mattn/excitetranslate-vim ========================================================================== {{{

" key_mappings {{{
nnoremap [fpref]t           :<C-u>ExciteTranslate<CR>
" }}}

" }}}

" === tomtom/tcomment_vim ================================================================================ {{{

" key_mappings {{{
nmap \c <Plug>TComment_gcc<Esc>
vmap \c <Plug>TComment_gcc<Esc>
" }}}

" }}}

" === tpope/vim-repeat =================================================================================== {{{

" key_mappings {{{
nmap s <Plug>(operator-replace)
" }}}

" }}}

" === junegunn/vim-easy-align ============================================================================ {{{

" key_mappings {{{
vmap <Enter> <Plug>(EasyAlign)
" }}}

" }}}

" === base settings ====================================================================================== {{{

" modeline
set modeline
set modelines =3

" function
set history  =1024   " number of history
set helplang =en     " language to read help

" encoding
set encoding        =utf-8           " character code for .vimrc
set fileencoding    =utf-8           " character code to write files
set fileencodings   =utf-8,sjis      " character code to read file (default)
set fileencodings  +=ucs-bom         " character code to read file
set fileencodings  +=iso-2022-jp-3   " character code to read file
set fileencodings  +=iso-2022-jp     " character code to read file
set fileencodings  +=eucjp-ms        " character code to read file
set fileencodings  +=euc-jisx0213    " character code to read file
set fileencodings  +=euc-jp          " character code to read file
set fileencodings  +=cp932           " character code to read file
set fileformats     =unix,dos,mac    " newline character

" view
syntax on                  " show syntax hilight
set number                 " show line number
set ruler                  " show current line number
set title                  " show title of the file
set showmatch              " show matching bracket
set virtualedit  +=block   " expand bounds in visual mode
set nowrap                 " nowrap
set t_Co          =256     " terminal color
set equalalways            " adjust window size

" indent
set backspace   =indent,eol,start   " more powerful backspacing
set smartindent                     " indent automatically
set autoindent                      " indent automatically
set shiftwidth  =4                  " width of indent for autoindent
set tabstop     =4                  " width of TAB
set expandtab                       " change TAB to space
set textwidth   =0                  " text width

" searching
set incsearch   " disable increment search
set wrapscan    " searchrs wrap around

" command line
vmap     <Enter>            <Plug>(EasyAlign)
set timeoutlen =10000      " time to wait for a key code

" action
set autoread              " reload file automatically when it is updated
set scrolloff  =10        " scrooloff
set clipboard  =unnamed   " sharing clipboard

" fold
set foldenable            " enable fold
set foldcolumn  =0        " width of folding guide
set foldmethod  =marker   " folding by {{{.}}}

" directories
if !isdirectory(expand('~/.vimfiles'))
    call mkdir(expand('~/.vimfiles'))
endif
set browsedir  =current       " directiry to save editing files
set backup                    " make backup file
set backupdir  =~/.vimfiles   " directiry to save backup files
set undofile                  " make undo file
set undodir    =~/.vimfiles   " directiry to save undo files
set swapfile                  " make swap file
set directory  =~/.vimfiles   " directiry to save swap files

" colorscheme
colorscheme jellybeans

" }}}

