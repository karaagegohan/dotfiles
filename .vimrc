" === Initialization ===================================================================================== {{{

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" }}}

" === Functions and Constants ============================================================================ {{{

let s:is_terminal = !has('gui_running')
let s:is_windows  = has('win16') || has('win32') || has('win64')
let s:is_mac      = !s:is_windows
let s:is_cygwin   = has('win32unix')

function! s:My_mkdir(name) abort
    if !isdirectory(expand(a:name))
        call mkdir(expand(a:name))
    endif
endfunction

function! s:transparancy_up()
    if s:is_windows
        if &transparency - 5 > 1
            set transparency-=5
        else
            set transparency =1
        endif
    else 
        if &transparency + 2 < 100
            set transparency+=2
        else
            set transparency =100
        endif
    endif
endfunction 
command! MyTransparancyUp call s:transparancy_up()

function! s:transparancy_down()
    if s:is_windows
        if &transparency + 5 < 255
            set transparency+=5
        else
            set transparency =255
        endif
    else
        if &transparency - 2 > 0
            set transparency-=2
        else
            set transparency =0
        endif
    endif
endfunction 
command! MyTransparancyDown call s:transparancy_down()

function! s:fullscreen()
    if !s:is_terminal
        if s:is_mac
            set fullscreen!
        else
            set columns =999
            set lines   =999
        endif
    endif
endfunction
command! MyFullscreen call s:fullscreen()

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
noremap! <C-c>              <Esc>
noremap  <C-c>              <Esc>
nnoremap <silent><C-c><C-c> :<C-u>nohlsearch<CR>
nnoremap <silent><CR>       :<C-u>write<CR>
nnoremap <silent><BS>       :<C-u>quit<CR>
nnoremap U                  <C-r>

" edit
nnoremap Y                  y$
nnoremap R                  J

" cursor
nnoremap j                  gj
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
nmap     '                  *
nmap     "                  #

" increment, decrement
nnoremap +                  <C-a>
nnoremap _                  <C-x>

" window
nnoremap <C-h>              <C-w>h
nnoremap <C-j>              <C-w>j
nnoremap <C-k>              <C-w>k
nnoremap <C-l>              <C-w>l
nnoremap <silent>[func]n    :<C-u>new<CR>
nnoremap <silent>[func]v    :<C-u>vnew<CR>
nnoremap <silent>[func]N    :<C-u>split<CR>
nnoremap <silent>[func]V    :<C-u>vsplit<CR>
nnoremap <silent>[func]fs   :<C-u>MyFullscreen<CR>

" tab
nnoremap <TAB>              gt
nnoremap <S-TAB>            gT
nnoremap [func]t            :<C-u>tabnew<CR>

" command mode
cnoremap <C-n>              <DOWN>
cnoremap <C-p>              <UP>

" fold
nnoremap zz                 za

" View
if !s:is_terminal
    nnoremap <silent><          :<C-u>MyTransparancyDown<CR>
    nnoremap <silent>>          :<C-u>MyTransparancyUp<CR>
endif

" handy
if isdirectory(expand('~/dotfiles')) 
    nnoremap <silent>[func].    :<C-u>edit ~/dotfiles/.vimrc<CR>
    nnoremap <silent>[func],    :<C-u>edit ~/dotfiles/.gvimrc<CR>
else 
    nnoremap <silent>[func].    :<C-u>edit $MYVIMRC<CR>
    nnoremap <silent>[func],    :<C-u>edit $MYGVIMRC<CR>
endif
nnoremap <silent>[func]r    :<C-u>source $MYVIMRC<CR>:<C-u>source $MYGVIMRC<CR>
nnoremap <silent>[func]km   :/key_mappings<CR>zO
nnoremap [func]h            :<C-u>help 
nnoremap [func]e            :<C-u>edit<CR> 

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
NeoBundle 'Shougo/vimproc.vim', { 'build' : { 'windows' : 'make -f make_mingw32.mak', 'cygwin' : 'make -f make_cygwin.mak ', 'mac' : 'make -f make_mac.mak ', 'unix' : 'make -f make_unix.mak ', }, }

" complement 
if has('lua') 
    NeoBundleLazy 'Shougo/neocomplete.vim', { 'autoload' : { 'insert' : 1 } }
else 
    NeoBundleLazy 'Shougo/neocomplcache.vim', { 'autoload' : { 'insert' : 1 } }
endif
NeoBundleLazy 'Shougo/neosnippet', { 'autoload' : { 'insert' : 1 } }
NeoBundleLazy 'Shougo/neosnippet-snippets', { 'autoload' : { 'insert' : 1 }, 'depends' : ['Shougo/neosnippet'] }
NeoBundleLazy 'karaagegohan/my-snippets', { 'autoload' : { 'insert' : 1 }, 'depends' : ['Shougo/neosnippet'] }

NeoBundle 'Shougo/vimshell.vim'

NeoBundle 'kana/vim-smartchr'                  " Insert several candidates with a single key
NeoBundle 'itchyny/lightline.vim'              " Color command line
NeoBundle 'cohama/vim-hier'                    " Hilight quickfix errors
NeoBundle 'thinca/vim-quickrun'                " Run current code quickly
NeoBundle 'thinca/vim-qfreplace'               " Perform the replacement in quickfix
NeoBundle 'thinca/vim-visualstar'              " Use * in visual mode
NeoBundle 'rhysd/clever-f.vim'                 " Improve f{char}
NeoBundle 'tomtom/tcomment_vim'                " Comment out easily
NeoBundle 'junegunn/vim-easy-align'            " Align codes by delimiter
NeoBundle 'fuenor/qfixgrep'                    " Make notes easily
NeoBundle 'fuenor/qfixhowm'                    " Make notes easily
NeoBundle 'tpope/vim-repeat'                   " Enable to repeat plugins by '.'
NeoBundle 'tpope/vim-fugitive'                 " A Git wrapper
NeoBundle 'kien/rainbow_parentheses.vim'       " Better rainbow parentheses
NeoBundle 'LeafCage/yankround.vim'             " Paste yank history
NeoBundle 'Lokaltog/vim-easymotion'            " Powerful motion
NeoBundle 'Shougo/vimfiler.vim'                " Filer in vim
NeoBundle 'thinca/vim-fontzoom'                " Change font size
NeoBundle 'AndrewRadev/switch.vim'             " Switch segments
NeoBundle 't9md/vim-quickhl'                   " Highlight any words
NeoBundle 'airblade/vim-gitgutter'             " Viauallize diff of git
NeoBundle 'supermomonga/shaberu.vim'           " Shaberu in vim
NeoBundle 'rking/ag.vim'                       " Use ag command in vim
NeoBundle 'AndrewRadev/splitjoin.vim'          " Convert singlline to multiline 
NeoBundleLazy 'terryma/vim-multiple-cursors'   " Multiple cursol
NeoBundle 'mattn/unite-advent_calendar'        " View advent calendar
NeoBundle 'tyru/open-browser.vim'              " Make opening beowser easier
NeoBundle 'gregsexton/VimCalc'                 " Calculator in vim
NeoBundle 'osyo-manga/vim-anzu'                " Show a number of words hit search
NeoBundle 'osyo-manga/vim-over'                " Show words in substitude mode
NeoBundle 'mbbill/undotree'                    " Make undo tree
NeoBundle 'Shougo/vinarise.vim'                " Editing binary data
NeoBundle 'kana/vim-submode'                   " Use submode
NeoBundleLazy 'yuratomo/w3m.vim', { 'autoload' : { 'command' : ['W3m'] } }
NeoBundle 'thinca/vim-ref'                     " Reference
NeoBundle 'ringogirl/unite-w3m'                " Use w3m in Unite

" Textobject
NeoBundle 'kana/vim-textobj-user'               " Base plugin of textobject
NeoBundle 'sgur/vim-textobj-parameter'          " [,]  for parameter of function
NeoBundle 'kana/vim-textobj-indent'             " [i]  for indent
NeoBundle 'kana/vim-textobj-fold'               " [z]  for fold
NeoBundle 'kana/vim-textobj-underscore'         " [_]  for object between underscore
NeoBundle 'osyo-manga/vim-textobj-multiblock'   " [sb] for (), {}, [] etc...

" Operator
NeoBundle 'kana/vim-operator-user'       " Use vim-operator
NeoBundle 'tpope/vim-surround'           " Surround text obj with any word
NeoBundle 'kana/vim-operator-replace'    " Replace text obj with yanked word

" Syntax
NeoBundleLazy 'scrooloose/syntastic.git'     " Powerful syntax

" search
NeoBundle 'haya14busa/incsearch.vim'    " Make searching powerful

" Unite
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundleLazy 'Shougo/unite-outline', { 'autoload' : { 'unite_source' : ['outline'] } }
NeoBundleLazy 'ujihisa/unite-colorscheme', { 'autoload' : { 'unite_source' : ['colorscheme'] } }
NeoBundleLazy 'ujihisa/unite-font', { 'autoload' : { 'unite_source' : ['font'] } }
NeoBundleLazy 'ujihisa/unite-help', { 'autoload' : { 'unite_source' : ['help'] } }
NeoBundleLazy 'todashuta/unite-transparency', { 'autoload' : { 'unite_source' : ['transparency'] } }
NeoBundleLazy 'osyo-manga/unite-quickfix.git', { 'autoload' : { 'unite_source' : ['quickfix'] } }
NeoBundleLazy 'LeafCage/unite-gvimrgb', { 'autoload' : { 'unite_source' : ['gvimrgb'] } }
NeoBundleLazy 'LeafCage/unite-recording', { 'autoload' : { 'unite_source' : ['recording'] } }
NeoBundleLazy 'LeafCage/unite-highlight', { 'autoload' : { 'unite_source' : ['highlight'] } }
NeoBundleLazy 'LeafCage/unite-webcolorname', { 'autoload' : { 'unite_source' : ['webcolorname'] } }

" Java 
NeoBundleLazy 'vim-scripts/javacomplete', { 'build': { 'cygwin': 'javac autoload/Reflection.java', 'mac' : 'javac autoload/Reflection.java', 'unix' : 'javac autoload/Reflection.java', }, 'autoload' : { 'filetypes' : ['java'] } }
NeoBundleLazy 'moznion/java_getset.vim', { 'autoload': { 'filetypes': ['java'] } }

" Swift 
NeoBundleLazy 'keith/swift.vim', { 'autoload' : { 'filetypes' : ['swift'] } }

" C#
NeoBundleLazy 'OmniSharp/omnisharp-vim', { 'autoload': { 'filetypes': [ 'cs', 'csi', 'csx' ] }, 'build': { 'mac': 'xbuild server/OmniSharp.sln', 'unix': 'xbuild server/OmniSharp.sln', }, } 
NeoBundleLazy 'tpope/vim-dispatch', { 'autoload': { 'filetypes': [ 'cs', 'csi', 'csx' ] } }
NeoBundleLazy 'OrangeT/vim-csharp', { 'autoload': { 'filetypes': [ 'cs', 'csi', 'csx' ] } }

" Twitter
NeoBundleLazy 'basyura/TweetVim'
NeoBundleLazy 'basyura/bitly.vim'
NeoBundleLazy 'basyura/twibill.vim'

" colorscheme 
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'morhetz/gruvbox'
NeoBundle 'buttercream.vim'

" dictionary
NeoBundleLazy 'mattn/excitetranslate-vim', { 'depends' : 'mattn/webapi-vim', 'autoload' : { 'commands': ['ExciteTranslate']} }
NeoBundle 'mattn/webapi-vim'
NeoBundle 'ujihisa/neco-look'

" iTunes
NeoBundleLazy 'VimItunes.vim'

call neobundle#end()

NeoBundleCheck
filetype plugin indent on

" }}}

" === Shougo/neocomplete.vim ============================================================================= {{{
if neobundle#tap('neocomplete.vim')

    let g:neocomplete#enable_at_startup                 = 1         " Use neocomplete.
    let g:neocomplete#enable_smart_case                 = 1         " Use smartcase.
    let g:neocomplete#enable_camel_case                 = 1         " Use camelcase.
    let g:neocomplete#enable_fuzzy_completion           = 1         " Use fuzzy completion.
    let g:neocomplete#use_vimproc                       = 1
    let g:neocomplete#lock_iminsert                     = 1         " 
    let g:neocomplete#sources#syntax#min_keyword_length = 2
    let g:neocomplete#lock_buffer_name_pattern          = '\*ku\*'  " File name to lock buffer

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
        autocmd!
        autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd FileType cs            setlocal omnifunc=OmniSharp#Complete
    augroup END

    let g:neocomplete#force_overwrite_completefunc=1

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.c   = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.cs  = '.*[^=\);]'




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
endif
" }}}

" === Shougo/neocomplcache.vim =========================================================================== {{{
if neobundle#tap('neocomplcache.vim')

    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_ignore_case = 1
    let g:neocomplcache_enable_smart_case = 1
    if !exists('g:neocomplcache_keyword_patterns')
        let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns._ = '\h\w*'
    let g:neocomplcache_enable_camel_case_completion = 1
    let g:neocomplcache_enable_underbar_completion = 1

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

" === OmniSharp/omnisharp-vim ============================================================================ {{{
if neobundle#tap('omnisharp-vim')
    "
    " " OmniSharp won't work without this setting
    " filetype plugin on
    "
    " "This is the default value, setting it isn't actually necessary
    " let g:OmniSharp_host = "http://localhost:2000"
    "
    " "Set the type lookup function to use the preview window instead of the status line
    " let g:OmniSharp_typeLookupInPreview = 0
    "
    " "Timeout in seconds to wait for a response from the server
    " let g:OmniSharp_timeout = 1
    "
    " "Showmatch significantly slows down omnicomplete
    " "when the first match contains parentheses.
    " set noshowmatch
    "
    " "Super tab settings - uncomment the next 4 lines
    " "let g:SuperTabDefaultCompletionType = 'context'
    " "let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
    " "let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
    " "let g:SuperTabClosePreviewOnPopupClose = 1
    "
    " "don't autoselect first item in omnicomplete, show if only one item (for preview)
    " "remove preview if you don't want to see any documentation whatsoever.
    " set completeopt=longest,menuone,preview
    " " Fetch full documentation during omnicomplete requests.
    " " There is a performance penalty with this (especially on Mono)
    " " By default, only Type/Method signatures are fetched. Full documentation can still be fetched when
    " " you need it with the :OmniSharpDocumentation command.
    " " let g:omnicomplete_fetch_documentation=1
    "
    " "Move the preview window (code documentation) to the bottom of the screen, so it doesn't move the code!
    " "You might also want to look at the echodoc plugin
    " set splitbelow
    "
    " " Get Code Issues and syntax errors
    " let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
    " " If you are using the omnisharp-roslyn backend, use the following
    " " let g:syntastic_cs_checkers = ['code_checker']
    " augroup omnisharp_commands
    "     autocmd!
    "
    "     "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
    "     autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
    "
    "     " Synchronous build (blocks Vim)
    "     "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
    "     " Builds can also run asynchronously with vim-dispatch installed
    "     autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
    "     " automatic syntax check on events (TextChanged requires Vim 7.4)
    "     autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck
    "
    "     " Automatically add new cs files to the nearest project on save
    "     autocmd BufWritePost *.cs call OmniSharp#AddToProject()
    "
    "     "show type information automatically when the cursor stops moving
    "     autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
    "
    "     "The following commands are contextual, based on the current cursor position.
    "
    "     autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
    "     autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
    "     autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
    "     autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
    "     autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
    "     "finds members in the current buffer
    "     autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
    "     " cursor can be anywhere on the line containing an issue
    "     autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
    "     autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
    "     autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
    "     autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
    "     "navigate up by method/property/field
    "     autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
    "     "navigate down by method/property/field
    "     autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>
    "
    " augroup END
    "
    "
    " " this setting controls how long to wait (in ms) before fetching type / symbol information.
    " set updatetime=500
    " " Remove 'Press Enter to continue' message when type information is longer than one line.
    " set cmdheight=2
    "
    " " Contextual code actions (requires CtrlP or unite.vim)
    " nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
    " " Run code actions with text selected in visual mode to extract method
    " vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>
    "
    " " rename with dialog
    " nnoremap <leader>nm :OmniSharpRename<cr>
    " nnoremap <F2> :OmniSharpRename<cr>
    " " rename without dialog - with cursor on the symbol to rename... ':Rename newname'
    " command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")
    "
    " " Force OmniSharp to reload the solution. Useful when switching branches etc.
    " nnoremap <leader>rl :OmniSharpReloadSolution<cr>
    " nnoremap <leader>cf :OmniSharpCodeFormat<cr>
    " " Load the current .cs file to the nearest project
    " nnoremap <leader>tp :OmniSharpAddToProject<cr>
    "
    " " (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
    " nnoremap <leader>ss :OmniSharpStartServer<cr>
    " nnoremap <leader>sp :OmniSharpStopServer<cr>
    "
    " " Add syntax highlighting for types and interfaces
    " nnoremap <leader>th :OmniSharpHighlightTypes<cr>
    " "Don't ask to save when changing buffers (i.e. when jumping to a type definition)
    " set hidden
    " function! s:km_omnisharp()
    "     " prefix
    "     nnoremap [omnishar] <Nop>
    "     nmap     [plugin]o   [omnishar]
    "
    "     nnoremap <silent><buffer>[omnishar]a :<C-u>OmniSharpAddToProject<CR>
    "     nnoremap <silent><buffer>[omnishar]b :<C-u>OmniSharpBuild<CR>
    "     nnoremap <silent><buffer>[omnishar]e :<C-u>OmniSharpFindSyntaxErrors<CR>
    "     nnoremap <silent><buffer>[omnishar]c :<C-u>OmniSharpCodeFormat<CR>
    "     nnoremap <silent><buffer>[omnishar]d :<C-u>OmniSharpGotoDefinition<CR>
    "     nnoremap <silent><buffer>[omnishar]i :<C-u>OmniSharpFindImplementations<CR>
    "     nnoremap <silent><buffer>[omnishar]r :<C-u>OmniSharpRename<CR>
    "     nnoremap <silent><buffer>[omnishar]l :<C-u>OmniSharpTypeLookup<CR>
    "     nnoremap <silent><buffer>[omnishar]f :<C-u>OmniSharpFindUsages<CR>
    "     nnoremap <silent><buffer>[omnishar]a :<C-u>OmniSharpGetCodeActions<CR>
    " endfunction
    "
endif
" }}}

" === Shougo/unite.vim =================================================================================== {{{
if neobundle#tap('unite.vim')

    let g:unite_source_history_yank_enable      = 1     " Enable history yank
    let g:unite_source_file_mru_limit           = 200   " Maximum number of mru list
    let g:unite_source_file_mru_filename_format = ''    " Maximum number of mru list
    let g:unite_enable_start_insert             = 1     " Start in insert mode

    " key_mappings {{{
    " prefix
    nnoremap [unite]   <Nop>
    nmap     [plugin]u [unite]

    nnoremap [unite]u  :<C-u>Unite<CR>
    nnoremap [unite]hy :<C-u>Unite history/yank<CR>
    nnoremap [unite]he :<C-u>Unite help<CR>
    nnoremap [unite]hf :<C-u>Unite file_mru buffer<CR>
    nnoremap [unite]b  :<C-u>Unite buffer<CR>
    nnoremap [unite]r  :<C-u>Unite -buffer-name=register register<CR>
    nnoremap [unite]f  :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
    nnoremap [unite]qf :<C-u>Unite -no-quit -direction=botright quickfix<CR>
    nnoremap [unite]pc :<C-u>Unite -auto-preview colorscheme<CR>
    nnoremap [unite]pf :<C-u>Unite -auto-preview font<CR>
    nnoremap [unite]pt :<C-u>Unite -auto-preview transparency<CR>
    nnoremap [unite]yr :<C-u>Unite yankround<CR>
    nnoremap [unite]nb :<C-u>Unite neobundle<CR>
    nnoremap [unite]co :<C-u>Unite command<CR>
    " }}}

endif
" }}}

" === Shougo/unite-outline =============================================================================== {{{
if neobundle#tap('unite-outline')

    let g:unite_split_rule = 'botright'

endif
" }}}

" === Shougo/vimfiler.vim ================================================================================ {{{
if neobundle#tap('vimfiler.vim')

    let g:vimfiler_enable_auto_cd = 1

    " key_mappings {{{
    " prefix
    nnoremap [filer]   <Nop>
    nmap     [plugin]f [filer]

    nnoremap [filer]  :<C-u>VimFiler<CR>
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

    let g:vimshell_prompt_expr = 'getcwd()." > "'
    let g:vimshell_prompt_pattern = '^\f\+ > '

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

" === itchyny/lightline.vim ============================================================================== {{{
if neobundle#tap('lightline.vim')

    let g:lightline = {
        \ 'colorscheme': 'solarized',
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
        \     'pattern':      '+=\|=',
        \     'left_margin':  2,
        \     'right_margin': 0
        \   },
        \ }

endif
" }}}

" === fuenor/qfixhowm ==================================================================================== {{{
if neobundle#tap('qfixhowm')

    if isdirectory(expand('~/Google\ Drive'))
        if s:is_windows
            if !isdirectory(expand('~/Google\ Drive/Memo'))
                call mkdir('~/Google\ Drive/Memo', 'p')
            endif
            let howm_dir                   = '~/Google\ Drive/Memo'              " directory
            let QFixMRU_Filename           = '~/Google\ Drive/Memo/.qfixmru'     " MRU file
        else
            if !isdirectory(expand('~/Google\ Drive/Memo'))
                call mkdir('~/Google\ Drive/Memo', 'p')
            endif
            let howm_dir                   = '~/Google\ Drive/Memo'              " directory
            let QFixMRU_Filename           = '~/Google\ Drive/Memo/.qfixmru'     " MRU file
        endif
    endif

    let QFixHowmQFixHowm_Key_DiaryFile = 'diary/%Y/%m/%Y-%m-%d-000000.txt'   " filename of diary
    let QFixHowm_Key                   = 'g'                                 " keymap of QFix first
    let QFixHowm_KeyB                  = ','                                 " keymap of QFix second
    let howm_filename                  = '%Y/%m/%Y-%m-%d-%H%M%S.txt'         " filename
    let howm_fileencoding              = 'utf-8'                             " character code
    let howm_fileformat                = 'unix'                              " return code
    let QFixHowm_MenuPreview           = 0                                   " preview in menu
    let QFixHowm_MenuKey               = 1                                   " invalid default keymaps

    " key_mappings {{{
    " prefix
    nnoremap [hown]      <Nop>
    nmap     [plugin]h   [hown]

    nmap     [hown]l     g,m
    nmap     [hown]n     g,c
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
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

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
    nmap \c <Plug>TComment_gcc<Esc><Esc>
    vmap \c <Plug>TComment_gcc<Esc><Esc>
    " }}}

endif
" }}}

" === kana/vim-operator-replace ========================================================================== {{{
if neobundle#tap('vim-operator-replace')

    " key_mappings {{{
    nmap s <Plug>(operator-replace)
    nmap S <Plug>(operator-replace)$
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

" === thinca/vim-fontzoom ================================================================================ {{{
if neobundle#tap('vim-fontzoom')

    " key_mappings {{{
    nnoremap + <Nop>
    nnoremap - <Nop>

    nmap + <Plug>(fontzoom-larger)
    nmap _ <Plug>(fontzoom-smaller)
    " }}}

endif
" }}}

" === AndrewRadev/switch.vim ============================================================================= {{{
if neobundle#tap('switch.vim')

    let g:switch_custom_definitions = [ ['NeoBundle', 'NeoBundleLazy'] ]

    " key_mappings {{{
    nnoremap <silent>- :<C-u>Switch<CR>
    " }}}

endif
" }}}

" === t9md/vim-quickhl =================================================================================== {{{
if neobundle#tap('vim-quickhl')

    " key_mappings {{{
    nmap { <Plug>(quickhl-manual-this)
    xmap { <Plug>(quickhl-manual-this)
    nmap } <Plug>(quickhl-manual-reset)
    xmap } <Plug>(quickhl-manual-reset)
    " }}}

endif
" }}}

" === terryma/vim-multiple-cursors ======================================================================= {{{
if neobundle#tap('vim-multiple-cursors')

    " key_mappings {{{
    nnoremap [plugin]mc :<C-u>MultipleCursorsFind 
    " }}}

endif
" }}}

" === gregsexton/VimCalc ================================================================================= {{{
if neobundle#tap('VimCalc')

    " key_mappings {{{
    nnoremap [plugin]ca :<C-u>Calc<CR>

    augroup keymapping_VimCalc
        autocmd!
        autocmd FileType vimcalc inoremap <buffer><silent><C-c> <ESC>:<C-u>quit<CR>
        " autocmd FileType vimcalc inoremap <buffer><silent>N 0
        " autocmd FileType vimcalc inoremap <buffer><silent>M 1
        " autocmd FileType vimcalc inoremap <buffer><silent>< 2
        " autocmd FileType vimcalc inoremap <buffer><silent>> 3
        " autocmd FileType vimcalc inoremap <buffer><silent>J 4
        " autocmd FileType vimcalc inoremap <buffer><silent>K 5
        " autocmd FileType vimcalc inoremap <buffer><silent>L 6
        " autocmd FileType vimcalc inoremap <buffer><silent>U 7
        " autocmd FileType vimcalc inoremap <buffer><silent>I 8
        " autocmd FileType vimcalc inoremap <buffer><silent>O 9
        " autocmd FileType vimcalc inoremap <buffer><silent>_ -
        " autocmd FileType vimcalc inoremap <buffer><silent>& /
    augroup END

    " }}}

endif
" }}}

" === osyo-manga/vim-anzu ================================================================================ {{{
if neobundle#tap('vim-anzu')

    let g:anzu_enable_CursorMoved_AnzuUpdateSearchStatus = 1

endif
" }}}

" === osyo-manga/vim-over ================================================================================ {{{
if neobundle#tap('vim-over')

    " key_mappings {{{
    nnoremap [func]s :<C-u>OverCommandLine<CR>%s/
    " }}}

endif
" }}}

" === basyura/TweetVim =================================================================================== {{{
if neobundle#tap('TweetVim')

endif
" }}}

" === Shougo/vinarise.vim ================================================================================ {{{
if neobundle#tap('vinarise.vim')

    " key_mappings {{{
    " prefixes
    nmap [vinarise] <Nop>
    nmap [plugin]v  [vinarise]

    nnoremap [vinarise]v :<C-u>Vinarise<CR>
    nnoremap [vinarise]b :<C-u>VinarisePluginBitmapView<CR>
    " }}}

endif
" }}}

" === mbbill/undotree ==================================================================================== {{{
if neobundle#tap('undotree')

    let g:undotree_SetFocusWhenToggle   = 1
    let g:undotree_WindowLayout         = 'topleft'
    let g:undotree_SplitWidth           = 35
    let g:undotree_diffAutoOpen         = 1
    let g:undotree_diffpanelHeight      = 25
    let g:undotree_RelativeTimestamp    = 1
    let g:undotree_TreeNodeShape        = '*'
    let g:undotree_HighlightChangedText = 1
    let g:undotree_HighlightSyntax      = "UnderLined"

    " key_mappings {{{
    " prefix
    nnoremap [undotr]   <Nop>
    nmap     [plugin]U [undotr]

    nnoremap [undotr]  :<C-u>UndotreeToggle<CR>
    " }}}

endif
" }}}

" === kana/vim-submode =================================================================================== {{{
if neobundle#tap('vim-submode')

    " winsize mode
    call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
    call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
    call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>-')
    call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>+')
    call submode#map('winsize', 'n', '', '>', '<C-w>>')
    call submode#map('winsize', 'n', '', '<', '<C-w><')
    call submode#map('winsize', 'n', '', '+', '<C-w>-')
    call submode#map('winsize', 'n', '', '-', '<C-w>+')

endif
" }}}

" === yuratomo/w3m.vim =================================================================================== {{{
if neobundle#tap('w3m.vim')

    " key_mappings {{{
    " prefixes
    nmap [w3m]     <Nop>
    nmap [plugin]w [w3m]

    nnoremap [w3m]v :<C-u>w3m google<CR>
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
set noshowmatch
set matchtime     =1          " Time of matching paren
set virtualedit  +=block      " Expand bounds in visual mode
set nowrap                    " Nowrap
set t_Co          =256        " Terminal color
set equalalways               " Adjust window size
set display       =lastline   " Display
set pumheight     =10         " Height of popup
set t_vb=                     " Visual bell of terminal
set visualbell                " Show visualbell
set noerrorbells              " Diable error bell
set completeopt=longest,menuone,preview
set splitbelow
set hidden

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
set autoread                          " Reload file automatically when it is updated
set scrolloff  =10                    " Scrooloff
set clipboard +=unnamedplus,unnamed   " Sharing clipboard

" fold
set foldenable            " Enable fold
set foldcolumn  =0        " Width of folding guide
set foldmethod  =marker   " Folding by {{{.}}}

" directories
cd ~
call s:My_mkdir('~/.vimfiles')
set browsedir  =current       " Directiry to save editing files
set backup                    " Make backup file
set backupdir  =~/.vimfiles   " Directiry to save backup files
set undofile                  " Make undo file
set undodir    =~/.vimfiles   " Directiry to save undo files
set swapfile                  " Make swap file
set directory  =~/.vimfiles   " Directiry to save swap files

" colorscheme
colorscheme solarized
set background =dark

" }}}

