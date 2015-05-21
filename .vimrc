scriptencoding utf-8
augroup vimrc
    autocmd!
augroup END

" NeoBundle  {{{

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
NeoBundle 'Shougo/vimfiler'
NeoBundle 'kana/vim-smartchr'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'cohama/vim-hier'
NeoBundle 'dannyob/quickfixstatus'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'rhysd/vim-operator-surround'
NeoBundle 'tyru/restart.vim'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'kana/vim-operator-replace'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'fuenor/qfixgrep'
NeoBundle 'fuenor/qfixhowm'
NeoBundle 'tpope/vim-repeat'

filetype plugin indent on
NeoBundleCheck
call neobundle#end()
" }}}

" Shougo/neocomplete.vim {{{
    let g:acp_enableAtStartup                           = 1         " Disable AutoComplPop.
    let g:neocomplete#enable_at_startup                 = 1         " Use neocomplete.
    let g:neocomplete#enable_smart_case                 = 1         " Use smartcase.
    let g:neocomplete#sources#syntax#min_keyword_length = 3         " Set minimum syntax keyword length.
    " let g:neocomplete#lock_buffer_name_pattern          = '\*ku\*'  " file name to lock buffer

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

" }}}

" Shougo/neosnippet {{{
" Plugin key-mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
" imap <expr><TAB> neosnippet#expandable_or_jumpable() ?\ "\<Plug>(neosnippet_expand_or_jump)"\: "\<TAB>"
" smap <expr><TAB> neosnippet#expandable_or_jumpable() ?\ "\<Plug>(neosnippet_expand_or_jump)"\: "\<TAB>"
" imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif
" }}}

" Shougo/unite.vim {{{
let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200
nnoremap <silent> [space]y :<C-u>Unite history/yank<CR>
nnoremap <silent> [space]b :<C-u>Unite buffer<CR>
nnoremap <silent> [space]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [space]r :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [space]u :<C-u>Unite file_mru buffer<CR>
" }}}

" Shougo/unite-outline {{{
let g:unite_split_rule = 'botright'
noremap [space]o <ESC>:Unite -vertical -winwidth=60 outline<Return>
" }}}

" Shougo/vimshell {{{
" ,is: シェルを起動
nnoremap <silent> ,is :VimShell<CR>
" ,ipy: pythonを非同期で起動
"nnoremap <silent> ,ipy :VimShellInteractive python<CR>
" ,irb: irbを非同期で起動
"nnoremap <silent> ,irb :VimShellInteractive irb<CR>
" ,ss: 非同期で開いたインタプリタに現在の行を評価させる
"vmap <silent> ,ss :VimShellSendString<CR>
" 選択中に,ss: 非同期で開いたインタプリタに選択行を評価させる
"nnoremap <silent> ,ss <S-v>:VimShellSendString<CR>
"" }}}

" Shougo/vimfiler {{{
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_enable_auto_cd = 1
" }}}

" kana/vim-smartchr {{{
inoremap <buffer> <expr> = smartchr#loop(' = ', ' == ', '=')
" }}} 

" itchyny/lightline.vim {{{
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

" junegunn/vim-easy-align {{{
let g:easy_align_delimiters = {
            \ '"': {
            \     'pattern':         '"',
            \     'delimiter_align': 'l',
            \     'left_margin':   2,
            \     'right_margin':   1,
            \     'ignore_groups':   ['!Comment'] },
            \ }
" }}}

" fuenor/qfixhowm " {{{

let QFixHowm_Key       = 'g'  " keymap of QFix
let howm_dir           = '~/Documents/Memo'
let howm_filename      = '%Y/%m/%Y-%m-%d-%H%M%S.txt'
let howm_fileencoding  = 'utf-8'
let howm_fileformat    = 'unix'
let QFixHowm_DiaryFile = 'diary/%Y/%m/%Y-%m-%d-000000.txt'

" }}}

" basic settings {{{

" modeline
set modeline
set modelines=3

" encoding
set encoding=utf-8                " character code for .vimrc
set fileencoding=utf-8            " character code to write files
set fileencodings=utf-8,sjis      " character code to read file
set fileencodings+=ucs-bom        " character code to read file
set fileencodings+=iso-2022-jp-3  " character code to read file
set fileencodings+=iso-2022-jp    " character code to read file
set fileencodings+=eucjp-ms       " character code to read file
set fileencodings+=euc-jisx0213   " character code to read file
set fileencodings+=euc-jp         " character code to read file
set fileencodings+=cp932          " character code to read file

" window
set backspace=2  " more powerful backspacing
set number       " show line number
set ruler        " show current line number
set title        " show title of the file
syntax on

" indent
set smartindent   " indent automatically
set autoindent    " indent automatically
set shiftwidth=4  " width of indent for autoindent
set tabstop=4     " width of TAB
set expandtab     " change TAB to space

" searching
set incsearch  " validate increment search
set showmatch  " show matching bracket

" action
set autoread           " reload file automatically when it is updated
set scrolloff=15       " scrooloff
set foldmethod=marker  " folding {{{.}}}
set clipboard=unnamed  " sharing clipboard

" directories
cd ~
set backupdir=~/vimFiles  " directiry to save backup files
set undodir=~/vimFiles    " directiry to save undo files
set directory=~/vimFiles  " directiry to save swap files
set browsedir=current     " directiry to save editing files

" }}}

" key mappings {{{

noremap <C-c> <Esc>
nnoremap <CR> :<C-u>w<CR>

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $
onoremap H ^
onoremap L $
cnoremap <C-j> <DOWN>
cnoremap <C-k> <UP>
nnoremap <Tab> <C-w><C-w>
nnoremap <silent> <C-c><C-c> :noh<CR>
nnoremap <silent> <space>f :VimFiler<CR>
nnoremap <silent> <space>v :vnew<CR>
nnoremap <silent> <space>n :new<CR>
nnoremap <silent> <space>. :e $MYVIMRC<CR>
nnoremap <silent> <space>, :e $MYGVIMRC<CR>
nnoremap <silent> <space>r :<C-u>source $MYVIMRC<CR> :<C-u>source $MYGVIMRC<CR>
nnoremap ; :
vnoremap ; :
nnoremap U <C-r>
nnoremap z za
nnoremap di( f(di(
nnoremap da( f(da(
nnoremap ci( f(ci(
nnoremap ca( f(ca(
nnoremap si( f(si(
nnoremap sa( f(sa(
nnoremap di{ f{di{
nnoremap da{ f{da{
nnoremap ci{ f{ci{
nnoremap ca{ f{ca{
nnoremap si{ f{si{
nnoremap sa{ f{sa{
nmap ys <Plug>(operator-surround-append)
nmap ds <Plug>(operator-surround-delete)
nmap cs <Plug>(operator-surround-replace)
nmap \c <Plug>TComment_gcc<Esc>
vmap \c <Plug>TComment_gcc<Esc>
vmap <Enter> <Plug>(EasyAlign)
" }}}

