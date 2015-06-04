" === Initialization ===================================================================================== {{{

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" }}}

" === Functions ========================================================================================== {{{

function! s:My_mkdir(name) abort
    if !isdirectory(expand(a:name))
        call mkdir(expand(a:name))
    endif
endfunction

" }}}

" === key_mappings ======================================================================================= {{{

" ***NOTE*** {{{
" --------------------------------------------------------------------------------
" |      | normal    | insert    | command   | visual    | select    | waiting   |
" |------------------------------------------------------------------------------|
" |  map |     @     |     -     |     -     |     @     |     @     |     @     |
" | map! |     -     |     @     |     @     |     -     |     -     |     -     |
" | vmap |     -     |     -     |     -     |     @     |     @     |     -     |
" | nmap |     @     |     -     |     -     |     -     |     -     |     -     |
" | imap |     -     |     @     |     -     |     -     |     -     |     -     |
" | cmap |     -     |     -     |     @     |     -     |     -     |     -     |
" | xmap |     -     |     -     |     -     |     @     |     -     |     -     |
" | smap |     -     |     -     |     -     |     -     |     @     |     -     |
" | omap |     -     |     -     |     -     |     -     |     -     |     @     |
" --------------------------------------------------------------------------------
" | -noremap: default key map (notreclusive)                                     |
" |     -map: plugins etc. (reclusive)                                           |
" --------------------------------------------------------------------------------
"  }}}

" prefixes
nnoremap [func]             <Nop>
nmap     ,                  [func]
nnoremap [plugin]           <Nop>
nmap     <Space>            [plugin]

" base mappimgs
noremap  ;                  :
noremap  :                  ;
noremap! ;                  :
noremap! :                  ;
noremap  <C-c>              <Esc>
noremap! <C-c>              <Esc>
inoremap <C-v>              <Esc>
nnoremap <silent><C-c><C-c> :<C-u>nohlsearch<CR>
nnoremap <silent><CR>       :<C-u>write<CR>
nnoremap <silent><BS>       :<C-u>quit<CR>
nnoremap U                  <C-r>
noremap  <UP>               <Nop>
noremap  <DOWN>             <Nop>
noremap  <LEFT>             <Nop>
noremap  <RIGHT>            <Nop>
noremap! <UP>               <Nop>
noremap! <DOWN>             <Nop>
noremap! <LEFT>             <Nop>
noremap! <RIGHT>            <Nop>

" edit
nnoremap Y                  y$
inoremap <BS>               <Nop>
nnoremap R                  J

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

" increment, decrement
nnoremap +                  <C-a>
nnoremap _                  <C-x>

" window
nnoremap <C-h>              <C-w>h
nnoremap <C-j>              <C-w>j
nnoremap <C-k>              <C-w>k
nnoremap <C-l>              <C-w>l
nnoremap <silent>[func]n    :<C-u>split<CR>
nnoremap <silent>[func]v    :<C-u>vsplit<CR>

" tab
nnoremap <TAB>              gt
nnoremap <S-TAB>            gT
nnoremap [func]t            :<C-u>tabnew<CR>

" command mode
cnoremap <C-n>              <DOWN>
cnoremap <C-p>              <UP>

" fold
nnoremap z                  za

" handy
if isdirectory(expand('~/dotfiles')) 
    nnoremap <silent>[func].    :<C-u>edit ~/dotfiles/.vimrc<CR>
    nnoremap <silent>[func],    :<C-u>edit ~/dotfiles/.gvimrc<CR>
else 
    nnoremap <silent>[func].    :<C-u>edit $MYVIMRC<CR>
    nnoremap <silent>[func],    :<C-u>edit $MYGVIMRC<CR>
endif
nnoremap <silent>[func]r    :<C-u>source $MYVIMRC<CR>:<C-u>source $MYGVIMRC<CR>
nnoremap <silent>[func]km   /key_mappings<CR>zo
nnoremap [func]h            :<C-u>help 
nnoremap [func]e            :<C-u>edit<CR> 


" dangerous key mappings
nnoremap ZZ                 <Nop>
nnoremap ZQ                 <Nop>

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
"         insert
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

NeoBundle 'kana/vim-smartchr'            " Insert several candidates with a single key
NeoBundle 'itchyny/lightline.vim'        " Color command line
NeoBundle 'cohama/vim-hier'              " Hilight quickfix errors
NeoBundle 'thinca/vim-quickrun'          " Run current code quickly
NeoBundle 'thinca/vim-qfreplace'         " Perform the replacement in quickfix
NeoBundle 'thinca/vim-visualstar'        " Use * in visual mode
NeoBundle 'rhysd/clever-f.vim'           " Improve f{char}
NeoBundle 'tomtom/tcomment_vim'          " Comment out easily
NeoBundle 'junegunn/vim-easy-align'      " Align codes by delimiter
NeoBundle 'fuenor/qfixgrep'              " Make notes easily
NeoBundle 'fuenor/qfixhowm'              " Make notes easily
NeoBundle 'tpope/vim-repeat'             " Enable to repeat plugins by '.'
NeoBundle 'tpope/vim-fugitive'           " A Git wrapper
NeoBundle 'kien/rainbow_parentheses.vim' " Better rainbow parentheses
NeoBundle 'LeafCage/yankround.vim'       " Paste yank history
NeoBundle 'Lokaltog/vim-easymotion'      " Powerful motion

" Textobject
NeoBundle 'kana/vim-textobj-user'               " Base plugin of textobject
NeoBundle 'sgur/vim-textobj-parameter'          " [,]  for parameter of function
NeoBundle 'osyo-manga/vim-textobj-multiblock'   " [sb] for (), {}, [] etc...
NeoBundle 'kana/vim-textobj-indent'             " [i]  for indent
NeoBundle 'kana/vim-textobj-fold'               " [z]  for fold
NeoBundle 'kana/vim-textobj-underscore'         " [_]  for object between underscore

" syntax
NeoBundle 'scrooloose/syntastic.git'     " Powerful syntax

" search
NeoBundle 'haya14busa/incsearch.vim'    " Make searching powerful

" Unite
NeoBundle 'Shougo/unite.vim'           " synthesis
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'ujihisa/unite-font'
NeoBundle 'ujihisa/unite-help'

" Operator
NeoBundle 'kana/vim-operator-user'       " Use vim-operator
NeoBundle 'tpope/vim-surround'           " Surround text obj with any word
NeoBundle 'kana/vim-operator-replace'    " Replace text obj with yanked word

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

" dictionary
NeoBundle 'mattn/webapi-vim'
NeoBundleLazy 'mattn/excitetranslate-vim', {
    \ 'depends': 'mattn/webapi-vim',
    \ 'autoload' : { 'commands': ['ExciteTranslate']}
    \ }
NeoBundle 'ujihisa/neco-look'

call neobundle#end()

NeoBundleCheck
filetype plugin indent on

" }}}

" === Shougo/neocomplete.vim ============================================================================= {{{
if neobundle#tap('neocomplete.vim')

    let g:acp_enableAtStartup                           = 1         " Disable AutoComplPop.
    let g:neocomplete#enable_at_startup                 = 1         " Use neocomplete.
    let g:neocomplete#enable_smart_case                 = 1         " Use smartcase.
    let g:neocomplete#sources#syntax#min_keyword_length = 1         " Set minimum syntax keyword length.
    let g:neocomplete#lock_buffer_name_pattern          = '\*ku\*'  " File name to lock buffer
    let g:neocomplete#lock_iminsert                     = 1         " 

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

endif
" }}}

" === Shougo/neocomplcache.vim =========================================================================== {{{
if neobundle#tap('neocomplcache.vim')

    " TODO

endif
" }}}

" === Shougo/neosnippet ================================================================================== {{{
if neobundle#tap('neosnippet')

    " For snippet_complete marker.
    if has('conceal')
        set conceallevel=2 
        set concealcursor=i
    endif

    " other snippets
    let g:neosnippet#snippets_directory='~/.vim/bundle/my-snippets/snippets'

    " key_mappings {{{
    imap <C-k> <Plug>(neosnippet_expand_or_jump)
    smap <C-k> <Plug>(neosnippet_expand_or_jump)
    xmap <C-k> <Plug>(neosnippet_expand_target)
    " }}}

endif
" }}}

" === tpope/vim-fugitive ================================================================================= {{{
if neobundle#tap('vim-fugitive')

    " key_mappings {{{
    " prefix
    nnoremap [git]     <Nop>
    nmap     [plugin]g [git]

    nnoremap [git]g    :<C-u>Git<CR>
    nnoremap [git]a    :<C-u>Gwrite<CR>
    nnoremap [git]d    :<C-u>Gdiff<CR>
    nnoremap [git]c    :<C-u>Gcommit -m ''<LEFT>
    nnoremap [git]ps   :<C-u>Git push origin master<CR>
    nnoremap [git]pl   :<C-u>Git pull<CR>
    nnoremap [git]st   :<C-u>Git status<CR>
    nnoremap [git]sh   :<C-u>Git stash<CR>
    " }}}

endif
" }}}

" === kana/vim-smartchr ================================================================================== {{{
if neobundle#tap('vim-smartchr')

    augroup vim_schar
        autocmd!
        autocmd FileType swift inoremap <buffer><expr>- smartchr#loop('-', ' -> ')
    augroup END
    inoremap <expr>= smartchr#loop(' = ', ' == ', '=')

endif
" }}}

" === Shougo/vimshell.vim ================================================================================ {{{
if neobundle#tap('vimshell.vim')

    " key_mappings {{{
    " prefix
    nnoremap [shell]   <Nop>
    nmap     [plugin]s [shell]

    nnoremap [shell]s :<C-u>VimShell<CR>
    nnoremap [shell]n :<C-u>VimShellPop<CR>
    nnoremap [shell]p :<C-u>VimShellInteractive python<CR>
    nnoremap [shell]r :<C-u>VimShellInteractive irb<CR>
    " }}}

endif
" }}}

" === Shougo/unite.vim =================================================================================== {{{
if neobundle#tap('unite.vim')

    let g:unite_source_history_yank_enable      = 1     " Enable history yank
    let g:unite_source_file_mru_limit           = 200   " Maximum number of mru list
    let g:unite_source_file_mru_filename_format = ''    " Maximum number of mru list
    let g:unite_enable_start_insert             = 0     " Start in insert mode

    " key_mappings {{{
    " prefix
    nnoremap [unite]   <Nop>
    nmap     [plugin]u [unite]

    nnoremap [unite]u  :<C-u>Unite<CR>
    nnoremap [unite]hy :<C-u>Unite history/yank<CR>
    nnoremap [unite]hf :<C-u>Unite file_mru buffer<CR>
    nnoremap [unite]b  :<C-u>Unite buffer<CR>
    nnoremap [unite]r  :<C-u>Unite -buffer-name=register register<CR>
    nnoremap [unite]f  :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
    nnoremap [unite]pc :<C-u>Unite -auto-preview colorscheme<CR>
    nnoremap [unite]pf :<C-u>Unite -auto-preview font<CR>
    " }}}

endif
" }}}

" === Shougo/unite-outline =============================================================================== {{{
if neobundle#tap('unite-outline')

    let g:unite_split_rule = 'botright'

endif
" }}}

" === itchyny/lightline.vim ============================================================================== {{{
if neobundle#tap('lightline.vim')

    let g:lightline = {
        \ 'colorscheme': 'jellybeans',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
        \ },
        \ 'component_function': {
        \   'modified': 'MyModified',
        \   'readonly': 'MyReadonly',
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode'
        \ }
        \ }

    function! MyModified()
        return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
    endfunction

    function! MyReadonly()
        return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
    endfunction

    function! MyFilename()
        return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
            \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
            \  &ft == 'unite' ? unite#get_status_string() :
            \  &ft == 'vimshell' ? vimshell#get_status_string() :
            \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
            \ ('' != MyModified() ? ' ' . MyModified() : '')
    endfunction

    function! MyFugitive()
        try
            if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
                return fugitive#head()
            endif
        catch
        endtry
        return ''
    endfunction

    function! MyFileformat()
        return winwidth(0) > 70 ? &fileformat : ''
    endfunction

    function! MyFiletype()
        return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
    endfunction

    function! MyFileencoding()
        return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
    endfunction

    function! MyMode()
        return winwidth(0) > 60 ? lightline#mode() : ''
    endfunction

endif
" }}}

" === junegunn/vim-easy-align ============================================================================ {{{
if neobundle#tap('vim-easy-align')

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

endif
" }}}

" === fuenor/qfixhowm ==================================================================================== {{{
if neobundle#tap('qfixhowm')

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

    " key_mappings {{{
    " prefix
    nnoremap [hown]      <Nop>
    nmap     [plugin]qfh [hown]
    nmap     [hown]l     g,m
    nmap     [hown]c     g,c
    nmap     [hown]q     g,q
    nmap     [hown],     g,,
    " }}}

endif
" }}}

" === kien/rainbow_parentheses.vim ======================================================================= {{{
if neobundle#tap('rainbow_parentheses.vim')

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

endif
" }}}

" === moznion/java_getset.vim ============================================================================ {{{
if neobundle#tap('java_getset.vim')

    let b:javagetset_enable_K_and_R = 1   " K$R style
    let b:javagetset_add_this       = 1   " add this.

    " key_mappings {{{
    augroup vim_java_getset
        autocmd!
        autocmd Filetype java call s:java_getset_mappings()
    augroup END

    function! s:java_getset_mappings()
        " prefix
        nnoremap [getset]  <Nop>
        nmap     [plugin]j [getset]
        nmap     <buffer>[getset]g <Plug>JavagetsetInsertGetterOnly
        nmap     <buffer>[getset]s <Plug>JavagetsetInsertSetterOnly
        nmap     <buffer>[getset]b <Plug>JavagetsetInsertBothGetterSetter
        vmap     <buffer>[getset]g <Plug>JavagetsetInsertGetterOnly
        vmap     <buffer>[getset]s <Plug>JavagetsetInsertSetterOnly
        vmap     <buffer>[getset]b <Plug>JavagetsetInsertBothGetterSetter
    endfunction
    " }}}

endif
" }}}

" === scrooloose/syntastic.git =========================================================================== {{{
if neobundle#tap('syntastic.git')

    let g:syntastic_enable_signs  = 1
    let g:syntastic_auto_loc_list = 2
    let g:syntastic_mode_map = {'mode': 'passive'} 

    " key_mappings {{{
    " prefix
    nnoremap [syantax]  <Nop>
    nmap     [plugin]c [syantax]
    nmap     <buffer>[syantax] :SyntaasticCHack
    " }}}


endif
" }}}

" === LeafCage/yankround.vim ============================================================================= {{{
if neobundle#tap('yankround.vim')

    let g:yankround_max_history = 100

    " key_mappings {{{
    nmap p     <Plug>(yankround-p)
    nmap P     <Plug>(yankround-P)
    nmap <C-p> <Plug>(yankround-prev)
    nmap <C-n> <Plug>(yankround-next)
    " }}}

endif
" }}}

" === Lokaltog/vim-easymotion ============================================================================ {{{
if neobundle#tap('vim-easymotion')

    let g:EasyMotion_keys       = 'jfurmvhgytnbkdieclsowxapqzJFURMVHGYTNBKDIECLSOWXAPQZ'
    let g:EasyMotion_grouping   = 1

    " key_mappings {{{
    map m <Plug>(easymotion-prefix)
    map f <Plug>(easymotion-fl)
    map t <Plug>(easymotion-tl)
    map F <Plug>(easymotion-Fl)
    map T <Plug>(easymotion-Tl)
    " }}}

endif
" }}}

" === mattn/excitetranslate-vim ========================================================================== {{{
if neobundle#tap('excitetranslate-vim')

    " key_mappings {{{
    nnoremap [plugin]t :<C-u>ExciteTranslate<CR>
    " }}}

endif
" }}}

" === tomtom/tcomment_vim ================================================================================ {{{
if neobundle#tap('tcomment_vim')

    " key_mappings {{{
    nmap \c <Plug>TComment_gcc<Esc>
    vmap \c <Plug>TComment_gcc<Esc>
    " }}}

endif
" }}}

" === tpope/vim-repeat =================================================================================== {{{
if neobundle#tap('vim-repeat')

    " key_mappings {{{
    nmap s <Plug>(operator-replace)
    " }}}

endif
" }}}

" === junegunn/vim-easy-align ============================================================================ {{{
if neobundle#tap('vim-easy-align')

    " key_mappings {{{
    vmap <Enter> <Plug>(EasyAlign)
    " }}}

endif
" }}}

" === thinca/vim-quickrun ================================================================================ {{{
if neobundle#tap('vim-quickrun')

    let g:quickrun_config = {
        \   "_" : {
        \       "runner" : "vimproc",
        \       "runner/vimproc/updatetime" : 60
        \   },
        \}

    " key_mappings {{{
    nnoremap [plugin]r :<C-u>QuickRun -runner vimproc<CR>
    " }}}

endif
" }}}

" === haya14busa/incsearch.vim =========================================================================== {{{
if neobundle#tap('incsearch.vim')

    let g:incsearch#magic = '\v'

    " key_mappings {{{
    nmap / <Plug>(incsearch-forward)
    nmap ? <Plug>(incsearch-backward)
    " }}}

endif
" }}}

" === base settings ====================================================================================== {{{

" modeline
set modeline
set modelines =3

" function
set history  =1024   " Number of history
set helplang =en     " Language to read help

" encoding
set encoding        =utf-8           " Character code for .vimrc
set fileencoding    =utf-8           " Character code to write files
set fileencodings   =utf-8,sjis      " Character code to read file (default)
set fileencodings  +=ucs-bom         " Character code to read file
set fileencodings  +=iso-2022-jp-3   " Character code to read file
set fileencodings  +=iso-2022-jp     " Character code to read file
set fileencodings  +=eucjp-ms        " Character code to read file
set fileencodings  +=euc-jisx0213    " Character code to read file
set fileencodings  +=euc-jp          " Character code to read file
set fileencodings  +=cp932           " Character code to read file
set fileformats     =unix,dos,mac    " Newline character

" view
syntax on                     " Show syntax hilight
set number                    " Show line number
set ruler                     " Show current line number
set title                     " Show title of the file
set showmatch                 " Show matching bracket
set matchtime     =1          " Time of matching paren
set virtualedit  +=block      " Expand bounds in visual mode
set nowrap                    " Nowrap
set t_Co          =256        " Terminal color
set equalalways               " Adjust window size
set display       =lastline   " Display
set pumheight     =40         " Height of popup

" indent
set backspace          =indent,eol,start   " More powerful backspacing
set smartindent                            " Indent automatically
set autoindent                             " Indent automatically
set shiftwidth         =4                  " Width of indent for autoindent
set tabstop            =4                  " Width of TAB
set expandtab                              " Change TAB to space
set textwidth          =0                  " Text width
let g:vim_indent_cont  =4                  " Space before \

" searching
set incsearch   " Disable increment search
set wrapscan    " Searchrs wrap around

" command line
set timeoutlen =10000      " time to wait for a key code

" action
set autoread              " Reload file automatically when it is updated
set scrolloff  =10        " Scrooloff
set clipboard  =unnamed   " Sharing clipboard

" fold
set foldenable            " Enable fold
set foldcolumn  =0        " Width of folding guide
set foldmethod  =marker   " Folding by {{{.}}}

" directories
call s:My_mkdir('~/.vimfiles')
set browsedir  =current       " Directiry to save editing files
set backup                    " Make backup file
set backupdir  =~/.vimfiles   " Directiry to save backup files
set undofile                  " Make undo file
set undodir    =~/.vimfiles   " Directiry to save undo files
set swapfile                  " Make swap file
set directory  =~/.vimfiles   " Directiry to save swap files

" colorscheme
colorscheme jellybeans

" }}}

