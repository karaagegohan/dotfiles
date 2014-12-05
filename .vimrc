"-----------------------------------------------------------------------
"   neobundle
" -----------------------------------------------------------------------
set nocompatible               " Be iMproved

if has('vim_starting')
set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc.vim', {
    \ 'build' : {
        \ 'windows' : 'make -f make_mingw32.mak',
        \ 'cygwin'  : 'make -f make_cygwin.mak ',
        \ 'mac'     : 'make -f make_mac.mak    ',
        \ 'unix'    : 'make -f make_unix.mak   ',
    \ },
\ }

filetype plugin indent on     " Required!

" Brief help
" :NeoBundleList          - list configured bundles
" :NeoBundleInstall(!)    - install(update) bundles
" :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles


" Bundle
function! s:meet_neocomplete_requirements()
    return has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
endfunction

if s:meet_neocomplete_requirements()
    NeoBundle 'Shougo/neocomplete.vim'
else
    NeoBundle 'Shougo/neocomplcache.vim'
endif

NeoBundle "tyru/caw.vim"
NeoBundle "Shougo/neosnippet"
NeoBundle "Shougo/neosnippet-snippets"
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundleLazy 'Shougo/vimshell.vim', {
    \ 'depends' : [ 'Shougo/vimproc.vim' ]
    \ }
NeoBundle 'Shougo/vimfiler'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'kana/vim-smartchr'
NeoBundle 'sakuraiyuta/commentout.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'cohama/vim-hier'
NeoBundle 'dannyob/quickfixstatus'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'scrooloose/nerdtree'

" NeoBundle Setup
" -----------------------------------------------------------------------
"    'Shougo/neocomplete.vim'
" -----------------------------------------------------------------------
"    'Shougo/neocomplcashe'
" -----------------------------------------------------------------------
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
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
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
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
    " inoremap <expr><TAB>    pumvisible() ? neocomplcache#close_popup() :"\<CR>"
endif

" -----------------------------------------------------------------------
"    'Shougo/neosnippet'
" -----------------------------------------------------------------------
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

" -----------------------------------------------------------------------
"    'Shougo/unite.vim'
" -----------------------------------------------------------------------
let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200
nnoremap <silent> [space]y :<C-u>Unite history/yank<CR>
nnoremap <silent> [space]b :<C-u>Unite buffer<CR>
nnoremap <silent> [space]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [space]r :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [space]u :<C-u>Unite file_mru buffer<CR>

" -----------------------------------------------------------------------
"    'Shougo/unite-outline'
" -----------------------------------------------------------------------
let g:unite_split_rule = 'botright'
noremap [space]o <ESC>:Unite -vertical -winwidth=60 outline<Return>

" -----------------------------------------------------------------------
"    'Shougo/vimshell'
" -----------------------------------------------------------------------
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

" -----------------------------------------------------------------------
"    'Shougo/vimfiler'
" -----------------------------------------------------------------------
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_enable_auto_cd = 1

" -----------------------------------------------------------------------
"    'Rip-Rip/clang_complete'
" -----------------------------------------------------------------------
set completeopt=menuone
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
let g:clang_complete_copen = 0
let g:clang_use_library = 1
let g:clang_library_path = '/usr/lib/llvm'
let g:clang_debug = 0
let g:clang_user_options = '-std= c++11'

" -----------------------------------------------------------------------
"    'kana/vim-smartchr'
" -----------------------------------------------------------------------
inoremap <buffer> <expr> = smartchr#loop(' = ', ' == ', '=')

" -----------------------------------------------------------------------
"    'sakuraiyuta/commentout.vim'
" -----------------------------------------------------------------------

" -----------------------------------------------------------------------
"    'itchyny/lightline.vim'
" -----------------------------------------------------------------------
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

" -----------------------------------------------------------------------
"   'cohama/vim-hier'
" -----------------------------------------------------------------------

" -----------------------------------------------------------------------
"   'dannyob/quickfixstatus'
" -----------------------------------------------------------------------

" -----------------------------------------------------------------------
"    Installation check.
" -----------------------------------------------------------------------
NeoBundleCheck

" -----------------------------------------------------------------------
"    colorscheme
" -----------------------------------------------------------------------
" solarized カラースキーム
  NeoBundle 'altercation/vim-colors-solarized'
" mustang カラースキーム
  NeoBundle 'croaker/mustang-vim'
" wombat カラースキーム
  NeoBundle 'jeffreyiacono/vim-colors-wombat'
" jellybeans カラースキーム
  NeoBundle 'nanotech/jellybeans.vim'
" lucius カラースキーム
  NeoBundle 'vim-scripts/Lucius'
" zenburn カラースキーム
  NeoBundle 'vim-scripts/Zenburn'
" mrkn256 カラースキーム
  NeoBundle 'mrkn/mrkn256.vim'
" railscasts カラースキーム
  NeoBundle 'jpo/vim-railscasts-theme'
" pyte カラースキーム
  NeoBundle 'therubymug/vim-pyte'
" molokai カラースキーム
  NeoBundle 'tomasr/molokai'
colorscheme molokai

"--------------------
" base settings
"--------------------
cd ~
set modelines=0		" CVE-2007-2438
set encoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing
set number
set autoread
set ruler
set autoindent
set incsearch
set showmatch
set smartindent
set shiftwidth=4
set expandtab
set guioptions=
set ts=4
set t_Co=256
set nowrap
set mouse=
set title
set cmdheight=1
set scrolloff=5
set backupdir=~/vimFiles
set undodir=~/vimFiles
set directory=~/vimFiles
set browsedir=current
syntax on

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup

" autocmd GUIEnter * set transparency=200

" 隠しファイルをデフォルトで表示させる
let NERDTreeShowHidden = 1
 
" デフォルトでツリーを表示させる
autocmd VimEnter * execute 'NERDTree'

"------------------
" key mappings
"------------------
no R <Nop>
no <C-c> <Nop>
nnoremap <Tab> <C-w><C-w> 
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>
nnoremap <C-c><C-c> :noh<CR>
nnoremap <space>r :QuickRun<CR>
nnoremap <space>f :VimFiler<CR>
nnoremap <space>v :vnew<CR>
nnoremap <space>n :new<CR>
nnoremap <space>t :NERDTree<CR>
nnoremap <space>. :e $MYVIMRC<CR>
nnoremap <space>, :e $MYGVIMRC<CR>
nnoremap ; :
nnoremap U <C-r>
cnoremap <C-j> <DOWN>
cnoremap <C-k> <UP>

nnoremap s <Nop>

" コメントアウトを切り替えるマッピング
" \c でカーソル行をコメントアウト
" 再度 \c でコメントアウトを解除
" 選択してから複数行の \c も可能
nmap \c <Plug>(caw:I:toggle)
vmap \c <Plug>(caw:I:toggle)

" \C でコメントアウトの解除
nmap \C <Plug>(caw:I:uncomment)
vmap \C <Plug>(caw:I:uncomment)
