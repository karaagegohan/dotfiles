scriptencoding utf-8

" NeoBundle  {{{
augroup vimrc
    autocmd!
augroup END

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
function! s:meet_neocomplete_requirements()
    return has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
endfunction
if s:meet_neocomplete_requirements()
    NeoBundle 'Shougo/neocomplete.vim'
else
    NeoBundle 'Shougo/neocomplcache.vim'
endif
NeoBundle "Shougo/neosnippet"
NeoBundle "Shougo/neosnippet-snippets"
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
NeoBundle 'tpope/vim-surround'
NeoBundle 'tyru/restart.vim'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'kana/vim-operator-replace'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'junegunn/vim-easy-align'

filetype plugin indent on
call neobundle#end()
NeoBundleCheck
" }}}

" Shougo/neocomplete.vim, Shougo/neocomplcashe {{{
if s:meet_neocomplete_requirements()
    " --------------------------------------------------------------------
    " neocomplete の設定
    " --------------------------------------------------------------------
    "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

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

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    function! s:my_cr_function()
        return neocomplete#close_popup() . "\<CR>"
        " For no inserting <CR> key.
        "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()

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

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

else
    " --------------------------------------------------------------------
    " neocomplcache の設定
    " --------------------------------------------------------------------
    "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplcache.
    let g:neocomplcache_enable_at_startup = 1
    " Use smartcase.
    let g:neocomplcache_enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplcache_min_syntax_length = 3
    let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

    " Enable heavy features.
    " Use camel case completion.
    "let g:neocomplcache_enable_camel_case_completion = 1
    " Use underbar completion.
    "let g:neocomplcache_enable_underbar_completion = 1

    " Define dictionary.
    let g:neocomplcache_dictionary_filetype_lists = {
                \ 'default' : '',
                \ 'vimshell' : $HOME.'/.vimshell_hist',
                \ 'scheme' : $HOME.'/.gosh_completions'
                \ }

    " Define keyword.
    if !exists('g:neocomplcache_keyword_patterns')
        let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplcache#undo_completion()
    inoremap <expr><C-l>     neocomplcache#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
        return neocomplcache#smart_close_popup() . "\<CR>"
        " For no inserting <CR> key.
        "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplcache#close_popup()
    inoremap <expr><C-e>  neocomplcache#cancel_popup()

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    let g:neocomplcache_force_overwrite_completefunc=1

    " Enable heavy omni completion.
    if !exists('g:neocomplcache_omni_patterns')
        let g:neocomplcache_omni_patterns = {}
    endif
    let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)' let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

    " <TAB> completion.
    " inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
    " inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
    " inoremap <expr><TAB>    pumvisible() ? neocomplcache#close_popup() :"\<CR>"
endif
" }}}

" Shougo/neosnippet {{{
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
"
" SuperTab like snippets behavior.
" imap <expr><TAB> neosnippet#expandable_or_jumpable() ?\ "\<Plug>(neosnippet_expand_or_jump)"\: "\<TAB>"
" smap <expr><TAB> neosnippet#expandable_or_jumpable() ?\ "\<Plug>(neosnippet_expand_or_jump)"\: "\<TAB>"
imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

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

" Rip-Rip/clang_complete {{{
set completeopt=menuone
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
let g:clang_complete_copen = 0
let g:clang_use_library = 1
let g:clang_library_path = '/usr/lib/llvm'
let g:clang_debug = 0
let g:clang_user_options = '-std= c++11'
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
noremap <C-c> <Esc>
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
nmap s <Plug>(operator-replace)
nmap \c <Plug>TComment_gcc<Esc>
vmap \c <Plug>TComment_gcc<Esc>
vmap <Enter> <Plug>(EasyAlign)
" }}}
