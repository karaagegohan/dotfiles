" initialization {{{
augroup vimrc
    autocmd!
augroup END

if !&compatible
  set nocompatible
endif

if has('vim_starting')
    " dein settings 
    let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
    let s:dein_dir = s:cache_home . '/dein'
    let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
    endif

    let &runtimepath = s:dein_repo_dir .",". &runtimepath
    let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
    let s:toml_file = expand('~/.config/nvim/dein.toml')
    let g:ynoca_toml_file = s:toml_file
    if dein#load_state(s:dein_dir)
        call dein#begin(s:dein_dir, [$MYVIMRC, s:toml_file])
        call dein#load_toml(s:toml_file)
        call dein#end()
        call dein#save_state()
    endif

    if dein#check_install()
        call dein#install()
    endif

    set encoding =utf-8           " Character code for .vimrc
endif


if has('vim_starting') && dein#check_install()
endif

" }}}

" functions {{{

function! s:my_mkdir(name) abort "{{{
    if !isdirectory(expand(a:name))
        call mkdir(expand(a:name))
    endif
endfunction
"}}}

function! s:transparancy_up() abort "{{{
    if has('gui_running')
        if has('mac')
            if &transparency - 5 > 1
                set transparency-=5
            else
                set transparency =0
            endif
        elseif has('win32') || has('win64')
            if &transparency - 5 > 1
                set transparency-=5
            else
                set transparency =1
            endif
        endif
    endif
endfunction
"}}}
command! -nargs=0 MyTransparancyUp call s:transparancy_up()

function! s:transparancy_down() abort "{{{
    if has('gui_running')
        if has('mac')
            if &transparency + 5 < 100
                set transparency+=5
            else
                set transparency =100
            endif
        elseif has('win32') || has('win64')
            if &transparency + 5 < 255
                set transparency+=5
            else
                set transparency =255
            endif
        endif
    endif
endfunction
"}}}
command! -nargs=0 MyTransparancyDown call s:transparancy_down()

function! s:fullscreen() abort "{{{
    if !!has('gui_running')
        if has('mac')
            set fullscreen!
        else
            set columns =999
            set lines   =999
        endif
    endif
endfunction
"}}}
command! -nargs=0 MyFullscreen call s:fullscreen()

function! s:toggleopt(optname) abort "{{{
    try
        exec( 'set ' . a:optname . '!')
        exec( 'echo  "[' . a:optname . ']" ' . '&' . a:optname . '==1 ? "on" : "off"')
    catch
        echo a:optname . " does not exist."
    endtry
endfunction
"}}}
command! -nargs=1 ToggleOpt call s:toggleopt(<f-args>)

function! s:copyandmove() abort "{{{
    function! s:matchcount(expr, pat, ...)
        let a:start = get(a:, "1", 0)
        let a:result = match(a:expr, a:pat, a:start)
        return a:result == -1 ? 0 : s:matchcount(a:expr, a:pat, a:result+1) + 1
    endfunction
    let s:reg = @"
    let s:cnt = s:matchcount(s:reg,  "\n") - 1
    execute ":normal p"
    execute ":normal " . s:cnt . "j"
endfunction
"}}}
command! -nargs=0 CopyAndMove call s:copyandmove()

function! s:translateword() abort "{{{
    let a:word = matchstr(expand("<cword>"), '[a-z]*', 0)
    let a:words = webapi#xml#parse(iconv(webapi#http#get('http://public.dejizo.jp/NetDicV09.asmx/SearchDicItemLite?Dic=EJdict&Word=' . a:word . '&Scope=HEADWORD&Match=EXACT&Merge=AND&Prof=XHTML&PageSize=20&PageIndex=0').content, 'utf-8', &encoding)).findAll('ItemID')
    if len(a:words) == 0
        echo '"' . a:word . '" ' . 'is not exist.'
    else
        for a:j in range(0, len(a:words) - 1)
            let a:item_id = a:words[a:j]['child'][0]
            let a:means = webapi#xml#parse(iconv(webapi#http#get('http://public.dejizo.jp/NetDicV09.asmx/GetDicItemLite?Dic=EJdict&Item=' . a:item_id . '&Loc=&Prof=XHTML').content, 'utf-8', &encoding)).findAll('div')[1]['child'][1]['child'][0]
            let a:tokens = split(a:means, '\v\t\zs')
            let a:num = len(a:words) == 1 ? '' : ' (' . (a:j + 1) . ')'
            echo '【' . a:word . a:num . '】'
            for a:i in range(0,  len(a:tokens) - 1)
                echo (a:i + 1) . ': ' . a:tokens[a:i]
            endfor
        endfor
    endif
endfunction
"}}}
command! -nargs=0 TranslateWord call s:translateword()

function! s:closewindow(force) abort "{{{
    let a:bufname = expand('%:p')
    if len(a:bufname) == 0
        let a:bufname = '[No name]'
    endif
    if winnr('$') == 1 && tabpagenr('$') == 1
        :enew
    else
        :quit
    endif
    echo '"' . a:bufname . '" closed'
endfunction
"}}}
command! -nargs=0 CloseWindow call s:closewindow(0)
command! -nargs=0 CloseWindowForce call s:closewindow(1)

function! s:add_if_dein_tap() abort "{{{
    let a:plugin_name = matchstr(getline('.'), '/\zs.\{-}\ze' . "'", 0)
    if a:plugin_name != ''
        let a:plugin_name = 'if dein#tap(' . "'" . a:plugin_name . "'" . ') "{' . '{' . '{'
        if len(getline('$')) > 0
            call append(line("$"), '')
        endif
        call append(line("$"), a:plugin_name)
        call append(line("$"), 'endif' . ' "}' . '}' . '}')
        call append(line("$"), '')
    endif
endfunction "}}}
command! -nargs=0 AddIfNeoBundeTap call s:add_if_dein_tap()

let s:prefix_list = {}
function! s:add_prefix(keymap, prefix) abort "{{{
    exec ('nnoremap ' . a:prefix . ' <Nop>')
    exec ('nmap ' . a:keymap . ' ' . a:prefix)
    let s:prefix_list[a:keymap] = a:prefix
endfunction "}}}
command! -nargs=+ Nnoremap call s:add_prefix(<f-args>)

function! s:show_prefix() abort "{{{
    let a:prefixes = sort(keys(s:prefix_list))
    for a:i in range(0, len(a:prefixes) - 1)
        echo a:prefixes[a:i] . "\t" . s:prefix_list[a:prefixes[a:i]]
    endfor
endfunction "}}}
command! -nargs=0 PrefixList call s:show_prefix()

function! s:run_pandoc(output) abort "{{{
    let a:extension =  matchstr(a:output, '\.\zs.*', 0)
    exec '!pandoc % -t ' . a:extension . ' -o ' . a:output
endfunction "}}}
command! -nargs=1 Pandoc call s:run_pandoc(<f-args>)

function! s:rm_swp() abort "{{{
    let a:currentfile = fnamemodify(expand('%'), ":t")
    let a:directory = &directory 
    echo a:directory
    exec '!rm ' . a:directory . '/' . a:currentfile . '.sw*'
endfunction "}}}
command! -nargs=0 RmSwp call s:rm_swp()

function! s:dic_under() abort "{{{
    let a:word = matchstr(expand("<cword>"), '[a-z]*', 0)
    exec 'Dictionary ' . a:word
endfunction "}}}
command! -nargs=0 DictionaryUnderWord call s:dic_under()

"}}}

" key mappings {{{

" ***NOTE*** {{{
" --------------------------------------------------------------------------------------------
" |      | normal    | insert    | command   | visual    | select    | waiting   | Lang-Arg  |
" |------------------------------------------------------------------------------|-----------|
" |  map |     @     |     -     |     -     |     @     |     @     |     @     |     -     |
" | map! |     -     |     @     |     @     |     -     |     -     |     -     |     -     |
" | lmap |     -     |     @     |     @     |     -     |     -     |     -     |     @     |
" | vmap |     -     |     -     |     -     |     @     |     @     |     -     |     -     |
" | nmap |     @     |     -     |     -     |     -     |     -     |     -     |     -     |
" | imap |     -     |     @     |     -     |     -     |     -     |     -     |     -     |
" | cmap |     -     |     -     |     @     |     -     |     -     |     -     |     -     |
" | xmap |     -     |     -     |     -     |     @     |     -     |     -     |     -     |
" | smap |     -     |     -     |     -     |     -     |     @     |     -     |     -     |
" | omap |     -     |     -     |     -     |     -     |     -     |     @     |     -     |
" --------------------------------------------------------------------------------------------
" | -noremap: default key map (notreclusive)                                                 |
" |     -map: plugins etc. (reclusive)                                                       |
" --------------------------------------------------------------------------------------------
"  }}}

" prefixes
Nnoremap ,                  <SID>[func]
Nnoremap <Space>            <SID>[plugin]

" basic
noremap  ;                  :
noremap  :                  ;
noremap! ;                  :
noremap! :                  ;
nnoremap <CR>               :<C-u>write<CR>
nnoremap <S-CR>             :<C-u>write!<CR>
nnoremap U                  <C-r>
noremap! <C-c>              <Esc>
noremap  <C-c>              <Esc>
nnoremap <C-c><C-c>         :<C-u>nohlsearch<CR>:<C-u>echo ""<CR>
inoremap jj                 <CR>
inoremap kk                 <Esc>
nnoremap <C-h>              <Nop>
nnoremap <C-j>              <Nop>
nnoremap <C-k>              <Nop>
nnoremap <C-l>              <Nop>

" edit
nnoremap Y                  y$
nnoremap R                  J
nnoremap x                  "_x
nnoremap X                  x

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

" window
nnoremap gh                    <C-w>h
nnoremap gj                    <C-w>j
nnoremap gk                    <C-w>k
nnoremap gl                    <C-w>l
nnoremap <silent><SID>[func]n  :<C-u>new<CR>
nnoremap <silent><SID>[func]v  :<C-u>vnew<CR>
nnoremap <silent><SID>[func]N  :<C-u>split<CR>
nnoremap <silent><SID>[func]V  :<C-u>vsplit<CR>
nnoremap <silent><SID>[func]fs :<C-u>MyFullscreen<CR>
nnoremap <S-Left>              <C-w><<CR>
nnoremap <S-Right>             <C-w>><CR>
nnoremap <S-Up>                <C-w>-<CR>
nnoremap <S-Down>              <C-w>+<CR>
nnoremap <silent><BS>          :<C-u>CloseWindow<CR>
nnoremap <silent><S-BS>        :<C-u>CloseWindowForce<CR>

" tab
nnoremap <TAB>              gt
nnoremap <S-TAB>            gT
nnoremap <SID>[func]t            :<C-u>tabnew<CR>

" command mode
cnoremap <C-n>              <DOWN>
cnoremap <C-p>              <UP>

" fold
nnoremap zz                 za

" toggle
nnoremap <silent><SID>[func]1 :<C-u>ToggleOpt number<CR>
nnoremap <silent><SID>[func]2 :<C-u>ToggleOpt relativenumber<CR>
nnoremap <silent><SID>[func]3 :<C-u>ToggleOpt autochdir<CR>
nnoremap <silent><SID>[func]4 :<C-u>ToggleOpt list<CR>
nnoremap <silent><SID>[func]5 :<C-u>ToggleOpt foldenable<CR>
nnoremap <silent><SID>[func]6 <Nop>
nnoremap <silent><SID>[func]7 <Nop>
nnoremap <silent><SID>[func]8 <Nop>
nnoremap <silent><SID>[func]9 <Nop>

" function keys
nnoremap <silent><F1>  <Nop>
nnoremap <silent><F2>  <Nop>
nnoremap <silent><F3>  <Nop>
nnoremap <silent><F4>  <Nop>
nnoremap <silent><F5>  :<C-u>Restart<CR>
nnoremap <silent><F6>  <Nop>
nnoremap <silent><F7>  <Nop>
nnoremap <silent><F8>  <Nop>
nnoremap <silent><F9>  <Nop>
nnoremap <silent><F10> <Nop>
nnoremap <silent><F11> :<C-u>MyFullscreen<CR>
nnoremap <silent><F12> <Nop>

" View
nnoremap <silent><UP>   :<C-u>MyTransparancyDown<CR>
nnoremap <silent><DOWN> :<C-u>MyTransparancyUp<CR>

" other
nnoremap <silent><SID>[func].    :<C-u>edit $MYVIMRC<CR>
nnoremap <silent><SID>[func],    :<C-u>edit $MYGVIMRC<CR>
nnoremap <silent><SID>[func]/    :<C-u>edit ~/.config/nvim/dein.toml<CR>
nnoremap <silent><SID>[func]r    :<C-u>source $MYVIMRC<CR>:<C-u>echo "\"" . expand("%:p") . "\" " . "Reloaded"<CR>
nnoremap <silent><SID>[func]h    :<C-u>help <C-r><C-w><CR>
nnoremap <silent><SID>[func]e    :<C-u>edit<CR>
nnoremap <silent><SID>[func]ch   q:
nnoremap <silent><SID>[func]x    :<C-u>exit<CR>
nnoremap <silent><SID>[func]d    :<C-u>DictionaryUnderWord<CR>

"}}}

" settings {{{

" indent
filetype plugin indent on

" modeline
set modeline
set modelines =3

" statusline
set laststatus=2

" function
set history  =1024   " Number of history
if 1
    set helplang =ja     " Language to read help
else
    set helplang =en     " Language to read help
endif

" encoding
set fileencoding    =utf-8           " Character code to write files
" set fileencodings   =utf-8,sjis      " Character code to read file (default)
set fileencodings  +=ucs-bom         " Character code to read file
set fileencodings  +=iso-2022-jp-3   " Character code to read file
set fileencodings  +=iso-2022-jp     " Character code to read file
set fileencodings  +=eucjp-ms        " Character code to read file
set fileencodings  +=euc-jisx0213    " Character code to read file
set fileencodings  +=euc-jp          " Character code to read file
set fileencodings  +=cp932           " Character code to read file
set fileformats     =unix,dos,mac    " Newline character
if has('win32') || has('win64')
    let &termencoding = &encoding
endif

" view
syntax on                     " Show syntax hilight
set number                    " Show line number
set ruler                     " Show current line number
set title                     " Show title of the file
" set showmatch                 " Show matching bracket
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
set completeopt   =longest,menuone,preview
set splitbelow
set hidden
set nocursorline
set ambiwidth     =single

" indent
set backspace         =indent,eol,start    " More powerful backspacing
set smartindent                            " Indent automatically
set autoindent                             " Indent automatically
set shiftwidth        =4                   " Width of indent for autoindent
set tabstop           =4                   " Width of TAB
set expandtab                              " Change TAB to space
set textwidth         =0                   " Text width
set whichwrap         =b,s,h,l,<,>,[,]     " Release limit of cursor
let g:vim_indent_cont =4                   " Space before \

" edit
set switchbuf=useopen   " use an existing buffer instaed of creating a new one
set iminsert=0
set imsearch=-1

" searching
set incsearch   " Disable increment search
set wrapscan    " Searchrs wrap around

" command line
set timeoutlen =2000      " time to wait for a key code

" action
set autoread                              " Reload file automatically when it is updated
set scrolloff      =10                    " Scrooloff
set sidescroll     =1                     " Unit of left and right scroll
set sidescrolloff  =8                     " Scrooloff
set clipboard     +=unnamedplus,unnamed   " Sharing clipboard
set nrformats      =
set autochdir

" fold
set foldenable            " Enable fold
set foldcolumn  =0        " Width of folding guide
set foldmethod  =marker   " Folding by {{{.}}}

" directories
set browsedir  =current     " Directiry to save editing files

call s:my_mkdir('~/.vim/bak')
set backup                  " Make backup file
set backupdir  =~/.vim/bak  " Directiry to save backup files

call s:my_mkdir('~/.vim/undo')
set undofile                 " Make undo file
set undodir    =~/.vim/undo " Directiry to save undo files

call s:my_mkdir('~/.vim/swp')
set swapfile                " Make swap file
set directory  =~/.vim/swp " Directiry to save swap files

" colorscheme
" set background =dark
colorscheme onedark

autocmd vimrc BufRead, FileType help setlocal nofoldenable
autocmd vimrc BufRead, BufNewFile *.ahk setlocal fileencoding=sjis

"}}}

if dein#tap('neocomplete.vim') "{{{

    let g:neocomplete#enable_at_startup                 = 1         " use neocomplete.
    let g:neocomplete#enable_smart_case                 = 1         " use smartcase.
    let g:neocomplete#enable_camel_case                 = 1         " use camelcase.
    let g:neocomplete#enable_fuzzy_completion           = 1         " use fuzzy completion.
    let g:neocomplete#use_vimproc                       = 1
    let g:neocomplete#lock_iminsert                     = 1         "
    let g:neocomplete#sources#syntax#min_keyword_length = 2
    let g:neocomplete#lock_buffer_name_pattern          = '\*ku\*'  " file name to lock buffer

    " define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $home.'/.vimshell_hist',
        \ 'scheme' : $home.'/.gosh_completions'
        \ }

    " define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " enable omni completion.
    autocmd vimrc filetype css           setlocal omnifunc=csscomplete#completecss
    autocmd vimrc filetype html,markdown setlocal omnifunc=htmlcomplete#completetags
    autocmd vimrc filetype javascript    setlocal omnifunc=javascriptcomplete#completejs
    autocmd vimrc filetype python        setlocal omnifunc=pythoncomplete#complete
    autocmd vimrc filetype xml           setlocal omnifunc=xmlcomplete#completetags
    autocmd vimrc filetype cs            setlocal omnifunc=omnisharp#complete

    let g:neocomplete#force_overwrite_completefunc=1

    " enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.c   = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.cs  = '.*[^=\);]'

    " plugin key-mappings.
    inoremap <expr><c-g>     neocomplete#undo_completion()
    inoremap <expr><c-l>     neocomplete#complete_common_string()

    " recommended key-mappings.
    " <cr>: close popup and save indent.
    inoremap <silent> <cr> <c-r>=<sid>my_cr_function()<cr>
    function! s:my_cr_function()
        return neocomplete#close_popup() . "\<cr>"
        " for no inserting <cr> key.
        "return pumvisible() ? neocomplete#close_popup() : "\<cr>"
    endfunction
    " <tab>: completion.
    inoremap <expr><tab>  pumvisible() ? "\<c-n>" : "\<tab>"
    " <c-h>, <bs>: close popup and delete backword char.
    inoremap <expr><c-h> neocomplete#smart_close_popup()."\<c-h>"
    inoremap <expr><bs> neocomplete#smart_close_popup()."\<c-h>"
    inoremap <expr><c-y>  neocomplete#close_popup()
    inoremap <expr><c-e>  neocomplete#cancel_popup()

    let g:neocomplete#sources#dictionary#dictionaries = {
        \   'ruby': $HOME . '/Dicts/dicts/ruby.dict',
        \ }

endif "}}}

if dein#tap('neocomplcache.vim') "{{{

    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_ignore_case = 1
    let g:neocomplcache_enable_smart_case = 1
    if !exists('g:neocomplcache_keyword_patterns')
        let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns._ = '\h\w*'
    let g:neocomplcache_enable_camel_case_completion = 1
    let g:neocomplcache_enable_underbar_completion = 1

endif "}}}

if dein#tap('deoplete.nvim') "{{{

    let g:deoplete#enable_at_startup = 1

endif "}}}

if dein#tap('neosnippet') "{{{

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
    "}}}

endif "}}}

if dein#tap('omnisharp-vim') "{{{
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
    "     nmap     <SID>[plugin]o   [omnishar]
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
endif "}}}

if dein#tap('unite.vim') "{{{

    let g:unite_source_history_yank_enable      = 1     " Enable history yank
    let g:unite_source_file_mru_limit           = 200   " Maximum number of mru list
    let g:unite_source_file_mru_filename_format = ''    " Maximum number of mru list
    let g:unite_enable_start_insert             = 1     " Start in insert mode
    let g:unite_source_history_yank_enable      = 1

    " key_mappings {{{
    Nnoremap <SID>[plugin]u <SID>[unite]
    nnoremap <SID>[unite]u  :<C-u>Unite<CR>
    nnoremap <SID>[unite]s  :<C-u>Unite source<CR>
    nnoremap <SID>[unite]hy :<C-u>Unite history/yank<CR>
    nnoremap <SID>[unite]he :<C-u>Unite help<CR>
    nnoremap <SID>[unite]hf :<C-u>Unite file_mru buffer<CR>
    nnoremap <SID>[unite]b  :<C-u>Unite buffer<CR>
    nnoremap <SID>[unite]r  :<C-u>Unite -buffer-name=register register<CR>
    nnoremap <SID>[unite]f  :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
    nnoremap <SID>[unite]qf :<C-u>Unite -no-quit -direction=botright quickfix<CR>
    nnoremap <SID>[unite]pc :<C-u>Unite -auto-preview colorscheme<CR>
    nnoremap <SID>[unite]pf :<C-u>Unite -auto-preview font<CR>
    nnoremap <SID>[unite]pt :<C-u>Unite -auto-preview transparency<CR>
    nnoremap <SID>[unite]yr :<C-u>Unite yankround<CR>
    nnoremap <SID>[unite]nb :<C-u>Unite dein<CR>
    nnoremap <SID>[unite]co :<C-u>Unite command<CR>
    "}}}

endif "}}}

if dein#tap('unite-outline') "{{{

    let g:unite_split_rule = 'botright'

endif "}}}

if dein#tap('vimfiler.vim') "{{{

    let g:vimfiler_enable_auto_cd = 1

    " key_mappings {{{
    Nnoremap <SID>[plugin]f <SID>[filer]
    nnoremap <SID>[filer]  :<C-u>VimFiler<CR>
    "}}}

endif "}}}

if dein#tap('vim-fugitive') "{{{

    function! s:git_update(comment) abort
        exec('Git add .')
        exec('Gcommit -m "' . a:comment . '"')
        exec('Git push origin master')
        exec('write')
    endfunction
    command! -nargs=1 Gupdate call s:git_update(<f-args>)

    " key_mappings {{{
    Nnoremap <SID>[plugin]g <SID>[git]
    nnoremap <SID>[git]it :<C-u>Git<Space>
    nnoremap <SID>[git]ad :<C-u>Gwrite<CR>
    nnoremap <SID>[git]di :<C-u>Gdiff<CR>
    nnoremap <SID>[git]bl :<C-u>Gblame<CR>
    nnoremap <SID>[git]co :<C-u>Gcommit -m ""<LEFT>
    nnoremap <SID>[git]ps :<C-u>Git push origin master<CR>
    nnoremap <SID>[git]pl :<C-u>Git pull<CR>
    nnoremap <SID>[git]st :<C-u>Git status<CR>
    nnoremap <SID>[git]sh :<C-u>Git stash<CR>
    nnoremap <SID>[git]ch :<C-u>Git checkout<Space>
    nnoremap <SID>[git]me :<C-u>Git merge<Space>
    nnoremap <SID>[git]br :<C-u>Git branch<Space>
    nnoremap <SID>[git]up :<C-u>Gupdate<Space>
    nnoremap <SID>[git]uu :<C-u>Gupdate update<CR>
    "}}}

endif "}}}

if dein#tap('vim-gitgutter') "{{{

    " key_mappings {{{
    nnoremap <silent><SID>[git]gt   :<C-u>GitGutterToggle<CR>
    nnoremap <silent><SID>[git]gh   :<C-u>GitGutterLineHighlightsToggle<CR>
    "}}}

endif "}}}

if dein#tap('vim-smartchr') "{{{
    " inoremap <expr>=  smartchr#loop(' = ', '=', ' == ')
    " inoremap <expr>\| smartchr#loop(' \| ', ' \|\| ', '\|')
    " inoremap <expr>&  smartchr#loop(' & ', ' && ', '&')
    " inoremap <expr>,  smartchr#loop(', ', ',')
    " inoremap <expr>(  smartchr#loop('( ', '(')
    " inoremap <expr>)  smartchr#loop(' )', ')')
    " inoremap <expr>:  smartchr#loop('; ', ';')
    "
    " autocmd vimrc FileType swift inoremap <buffer><expr>- smartchr#loop('-', ' -> ')

    if dein#tap('vim-smartinput') "{{{
        let lst = [  
            \ ['<',     "smartchr#loop(' < ', ' << ', '<')" ],
            \ ['>',     "smartchr#loop(' > ', ' >> ', ' >>> ', '>')"],
            \ ['+',     "smartchr#loop(' + ', ' ++ ', '+')"],
            \ ['-',     "smartchr#loop(' - ', ' -- ', '-')"],
            \ ['/',     "smartchr#loop(' / ', '//', '/')"],
            \ ['&',     "smartchr#loop(' & ', ' && ', '&')"],
            \ ['%',     "smartchr#loop(' % ', '%')"],
            \ ['*',     "smartchr#loop(' * ', '*')"],
            \ ['<Bar>', "smartchr#loop(' | ', ' || ', '|')"],
            \ [',',     "smartchr#loop(', ', ',')"]]

        for i in lst
            call smartinput#map_to_trigger('i', i[0], i[0], i[0])
            call smartinput#define_rule({ 'char' : i[0], 'at' : '\%#',                                      'input' : '<C-R>=' . i[1] . '<CR>'})
            call smartinput#define_rule({'char' : i[0], 'at' : '^\([^"]*"[^"]*"\)*[^"]*"[^"]*\%#',          'input' : i[0]})
            call smartinput#define_rule({ 'char' : i[0], 'at' : '^\([^'']*''[^'']*''\)*[^'']*''[^'']*\%#',  'input' : i[0] })
        endfor

        call smartinput#define_rule({'char' : '>', 'at' : ' < \%#', 'input' : '<BS><BS><BS><><Left>'})

        call smartinput#map_to_trigger('i', '=', '=', '=')
        call smartinput#define_rule({ 'char' : '=', 'at' : '\%#',                                       'input' : "<C-R>=smartchr#loop(' = ', ' == ', '=')<CR>"})
        call smartinput#define_rule({ 'char' : '=', 'at' : '[&+-/<>|] \%#',                             'input' : '<BS>= '})
        call smartinput#define_rule({ 'char' : '=', 'at' : '!\%#',                                      'input' : '= '})
        call smartinput#define_rule({ 'char' : '=', 'at' : '^\([^"]*"[^"]*"\)*[^"]*"[^"]*\%#',          'input' : '='})
        call smartinput#define_rule({ 'char' : '=', 'at' : '^\([^'']*''[^'']*''\)*[^'']*''[^'']*\%#',   'input' : '='})
        call smartinput#map_to_trigger('i', '<BS>', '<BS>', '<BS>')
        call smartinput#define_rule({ 'char' : '<BS>' , 'at' : '(\s*)\%#'   , 'input' : '<C-O>dF(<BS>'})
        call smartinput#define_rule({ 'char' : '<BS>' , 'at' : '{\s*}\%#'   , 'input' : '<C-O>dF{<BS>'})
        call smartinput#define_rule({ 'char' : '<BS>' , 'at' : '<\s*>\%#'   , 'input' : '<C-O>dF<<BS>'})
        call smartinput#define_rule({ 'char' : '<BS>' , 'at' : '\[\s*\]\%#' , 'input' : '<C-O>dF[<BS>'})

        for op in ['<', '>', '+', '-', '/', '&', '%', '\*', '|']
            call smartinput#define_rule({ 'char' : '<BS>' , 'at' : ' ' . op . ' \%#' , 'input' : '<BS><BS><BS>'})
        endfor

    endif "}}}

    
endif "}}}

if dein#tap('vimshell.vim') "{{{

    let g:vimshell_prompt_expr = 'getcwd()." > "'
    let g:vimshell_prompt_pattern = '^\f\+ > '

    " key_mappings {{{
    Nnoremap <SID>[plugin]s <SID>[shell]
    nnoremap <SID>[shell]s  :<C-u>set<space>noautochdir<CR>:<C-u>VimShell<CR>
    nnoremap <SID>[shell]n  :<C-u>set<space>noautochdir<CR>:<C-u>VimShellPop<CR>
    nnoremap <SID>[shell]p  :<C-u>set<space>noautochdir<CR>:<C-u>VimShellInteractive python<CR>
    nnoremap <SID>[shell]r  :<C-u>set<space>noautochdir<CR>:<C-u>VimShellInteractive irb<CR>
    "}}}

endif "}}}

if dein#tap('lightline.vim') "{{{

    let g:lightline = {
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [
        \     ['mode', 'paste'],
        \     ['time', 'fugitive', 'gitgutter', 'filename'],
        \   ],
        \   'right': [
        \     ['lineinfo', 'syntastic'],
        \     ['percent'],
        \     ['charcode', 'fileformat', 'fileencoding', 'filetype'],
        \   ]
        \ },
        \ 'component_function': {
        \   'modified': 'MyModified',
        \   'time': 'MyTime',
        \   'readonly': 'MyReadonly',
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode',
        \   'syntastic': 'SyntasticStatuslineFlag',
        \   'charcode': 'MyCharCode',
        \   'gitgutter': 'MyGitGutter',
        \ },
        \ 'separator': {'left': '', 'right': ''},
        \ 'subseparator': {'left': '|', 'right': '|'}
        \ }

    function! MyModified()
        return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
    endfunction

    function! MyTime()
        return winwidth('.') > 110 ? strftime("%Y/%m/%d %H:%M:%S", localtime()) : (winwidth('.') > 90 ? strftime("%Y/%m/%d", localtime()) : '')
    endfunction

    function! MyReadonly()
        return &ft !~? 'help\|vimfiler\|gundo' && &ro ? '-' : ''
    endfunction

    function! MyFilename()
        return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
            \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
            \  &ft == 'unite' ? unite#get_status_string() :
            \  &ft == 'vimshell' ? substitute(b:vimshell.current_dir,expand('~'),'~','') :
            \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
            \ ('' != MyModified() ? ' ' . MyModified() : '')
    endfunction

    function! MyFugitive()
        try
            if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
                let _ = fugitive#head()
                return strlen(_) ? _ : ''
            endif

        catch
        endtry
        return ''
    endfunction

    function! MyFileformat()
        return winwidth('.') > 70 ? &fileformat : ''
    endfunction

    function! MyFiletype()
        return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
    endfunction

    function! MyFileencoding()
        return winwidth('.') > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
    endfunction

    function! MyMode()
        return winwidth('.') > 60 ? lightline#mode() : ''
    endfunction

    function! MyGitGutter()
        if ! exists('*GitGutterGetHunkSummary')
            \ || ! get(g:, 'gitgutter_enabled', 0)
            \ || winwidth('.') <= 90
            return ''
        endif
        let symbols = [
            \ g:gitgutter_sign_added . ' ',
            \ g:gitgutter_sign_modified . ' ',
            \ g:gitgutter_sign_removed . ' '
            \ ]
        let hunks = GitGutterGetHunkSummary()
        let ret = []
        for i in [0, 1, 2]
            if hunks[i] > 0
                call add(ret, symbols[i] . hunks[i])
            endif
        endfor
        return join(ret, ' ')
    endfunction

    " https://github.com/Lokaltog/vim-powerline/blob/develop/autoload/Powerline/Functions.vim
    function! MyCharCode()
        if winwidth('.') <= 70
            return ''
        endif

        " Get the output of :ascii
        redir => ascii
        silent! ascii
        redir END

        if match(ascii, 'NUL') != -1
            return 'NUL'
        endif

        " Zero pad hex values
        let nrformat = '0x%02x'

        let encoding = (&fenc == '' ? &enc : &fenc)

        if encoding == 'utf-8'
            " Zero pad with 4 zeroes in unicode files
            let nrformat = '0x%04x'
        endif

        " Get the character and the numeric value from the return value of :ascii
        " This matches the two first pieces of the return value, e.g.
        " "<F>  70" => char: 'F', nr: '70'
        let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')

        " Format the numeric value
        let nr = printf(nrformat, nr)

        return "'". char ."' ". nr
    endfunction
endif "}}}

if dein#tap('qfixhowm') "{{{

    if isdirectory(expand('~/Google\ Drive'))
        if has('win32') || has('win64')
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
    Nnoremap <SID>[plugin]h   <SID>[hown]
    nmap     <SID>[hown]l     g,m
    nmap     <SID>[hown]n     g,c
    nmap     <SID>[hown]q     g,q
    nmap     <SID>[hown],     g,,
    "}}}

endif "}}}

if dein#tap('rainbow_parentheses.vim') "{{{

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

endif "}}}

if dein#tap('java_getset.vim') "{{{

    let b:javagetset_enable_K_and_R = 1   " K$R style
    let b:javagetset_add_this       = 1   " add this.

    " key_mappings {{{
    autocmd vimrc Filetype java Nnoremap <SID>[plugin]j <SID>[getset]
    autocmd vimrc Filetype java nmap     <buffer><SID>[getset]g <Plug>JavagetsetInsertGetterOnly
    autocmd vimrc Filetype java nmap     <buffer><SID>[getset]s <Plug>JavagetsetInsertSetterOnly
    autocmd vimrc Filetype java nmap     <buffer><SID>[getset]b <Plug>JavagetsetInsertBothGetterSetter
    autocmd vimrc Filetype java vmap     <buffer><SID>[getset]g <Plug>JavagetsetInsertGetterOnly
    autocmd vimrc Filetype java vmap     <buffer><SID>[getset]s <Plug>JavagetsetInsertSetterOnly
    autocmd vimrc Filetype java vmap     <buffer><SID>[getset]b <Plug>JavagetsetInsertBothGetterSetter
    "}}}

endif "}}}

if dein#tap('syntastic.git') "{{{

    let g:syntastic_enable_signs  = 1
    let g:syntastic_auto_loc_list = 2
    let g:syntastic_mode_map = {'mode': 'passive'}
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0

endif "}}}

if dein#tap('yankround.vim') "{{{

    let g:yankround_max_history = 100

    " key_mappings {{{
    nmap p     <Plug>(yankround-p)
    nmap P     <Plug>(yankround-P)
    nmap <C-p> <Plug>(yankround-prev)
    nmap <C-n> <Plug>(yankround-next)
    "}}}

endif "}}}

if dein#tap('vim-easymotion') "{{{

    " let g:EasyMotion_keys       = 'jfurmvhgytnbkdieclsowxapqzJFURMVHGYTNBKDIECLSOWXAPQZ'
    let g:EasyMotion_keys       = 'asdfghjkl'
    let g:EasyMotion_grouping   = 1

    " key_mappings {{{
    map m <Plug>(easymotion-prefix)
    map f <Plug>(easymotion-overwin-f)
    map t <Plug>(easymotion-tl)
    map F <Plug>(easymotion-Fl)
    map T <Plug>(easymotion-Tl)
    "}}}

endif "}}}

if dein#tap('excitetranslate-vim') "{{{

    " key_mappings {{{
    nnoremap <SID>[plugin]t :<C-u>ExciteTranslate<CR>
    "}}}

endif "}}}

if dein#tap('tcomment_vim') "{{{

    " key_mappings {{{
    nmap cc <Plug>TComment_gcc<Esc><Esc>
    vmap cc <Plug>TComment_gcc<Esc><Esc>
    "}}}

endif "}}}

if dein#tap('vim-easy-align') "{{{

    " key_mappings {{{
    vmap <Enter> <Plug>(EasyAlign)
    nmap ga      <Plug>(EasyAlign)
    xmap ga      <Plug>(EasyAlign)
    "}}}

endif "}}}

if dein#tap('vim-quickrun') "{{{

    let g:quickrun_config = {
        \   "_" : {
        \       "runner" : "vimproc",
        \       "runner/vimproc/updatetime" : 60
        \   },
        \}

    " key_mappings {{{
    nnoremap <SID>[plugin]r :<C-u>QuickRun -runner vimproc<CR>
    "}}}

endif "}}}

if dein#tap('incsearch.vim') "{{{

    let g:incsearch#magic = '\v'

    " key_mappings {{{
    nmap / <Plug>(incsearch-forward)
    nmap ? <Plug>(incsearch-backward)
    "}}}

endif "}}}

if dein#tap('vim-fontzoom') "{{{

    " key_mappings {{{
    nmap <RIGHT> <Plug>(fontzoom-larger)
    nmap <LEFT>  <Plug>(fontzoom-smaller)
    "}}}

endif "}}}

if dein#tap('switch.vim') "{{{

    let g:switch_custom_definitions = [ ['NeoBundle', 'NeoBundleLazy'] ]

    " key_mappings {{{
    nnoremap <silent>- :<C-u>Switch<CR>
    "}}}

endif "}}}

if dein#tap('vim-quickhl') "{{{

    " key_mappings {{{
    nmap { <Plug>(quickhl-manual-this)
    xmap { <Plug>(quickhl-manual-this)
    nmap } <Plug>(quickhl-manual-reset)
    xmap } <Plug>(quickhl-manual-reset)
    "}}}

endif "}}}

if dein#tap('vim-multiple-cursors') "{{{

    " key_mappings {{{
    nnoremap <SID>[plugin]mc :<C-u>MultipleCursorsFind
    "}}}

endif "}}}

if dein#tap('VimCalc') "{{{

    " key_mappings {{{
    nnoremap <SID>[plugin]ca :<C-u>Calc<CR>

    autocmd vimrc FileType vimcalc inoremap <buffer><silent><C-c> <ESC>:<C-u>quit<CR>
    " autocmd vimrc FileType vimcalc inoremap <buffer><silent>N 0
    " autocmd vimrc FileType vimcalc inoremap <buffer><silent>M 1
    " autocmd vimrc FileType vimcalc inoremap <buffer><silent>< 2
    " autocmd vimrc FileType vimcalc inoremap <buffer><silent>> 3
    " autocmd vimrc FileType vimcalc inoremap <buffer><silent>J 4
    " autocmd vimrc FileType vimcalc inoremap <buffer><silent>K 5
    " autocmd vimrc FileType vimcalc inoremap <buffer><silent>L 6
    " autocmd vimrc FileType vimcalc inoremap <buffer><silent>U 7
    " autocmd vimrc FileType vimcalc inoremap <buffer><silent>I 8
    " autocmd vimrc FileType vimcalc inoremap <buffer><silent>O 9
    " autocmd vimrc FileType vimcalc inoremap <buffer><silent>_ -
    " autocmd vimrc FileType vimcalc inoremap <buffer><silent>& /

    "}}}

endif "}}}

if dein#tap('vim-anzu') "{{{

    let g:anzu_enable_CursorMoved_AnzuUpdateSearchStatus = 1
    nmap n <Plug>(anzu-mode-n)
    nmap N <Plug>(anzu-mode-N)
    nnoremap <expr> n anzu#mode#mapexpr("n", "", "zzzv")
    nnoremap <expr> N anzu#mode#mapexpr("N", "", "zzzv")

endif "}}}

if dein#tap('vim-over') "{{{

    " key_mappings {{{
    nnoremap <SID>[func]s :<C-u>OverCommandLine<CR>%s/
    "}}}

endif "}}}

if dein#tap('TweetVim') "{{{

endif "}}}

if dein#tap('vinarise.vim') "{{{

    " key_mappings {{{
    Nnoremap <SID>[plugin]v <SID>[vinarise]
    nnoremap <SID>[vinarise]v :<C-u>Vinarise<CR>
    nnoremap <SID>[vinarise]b :<C-u>VinarisePluginBitmapView<CR>
    "}}}

endif "}}}

if dein#tap('undotree') "{{{

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
    Nnoremap <SID>[plugin]U <SID>[undotr]
    nnoremap <SID>[undotr]  :<C-u>UndotreeToggle<CR>
    "}}}

endif "}}}

if dein#tap('vim-submode') "{{{
    
    call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
    call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
    call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>-')
    call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>+')
    call submode#map('winsize', 'n', '', '>', '<C-w>>')
    call submode#map('winsize', 'n', '', '<', '<C-w><')
    call submode#map('winsize', 'n', '', '+', '<C-w>-')
    call submode#map('winsize', 'n', '', '-', '<C-w>+')

endif "}}}

if dein#tap('w3m.vim') "{{{

    " key_mappings {{{
    Nnoremap <SID>[plugin]w <SID>[w3m]
    nnoremap <SID>[w3m]g :<C-u>W3m google<CR>
    nnoremap <SID>[w3m]w :<C-u>W3m
    "}}}

endif "}}}

if dein#tap('vim-sound') "{{{

    " let s:soundfilename = expand("~/typewriter.wav")
    " autocmd vimrc InsertCharPre * call sound#play_wav(expand("~/typewriter.wav"))

endif "}}}

if dein#tap('vim-indent-guides') "{{{

    let g:indent_guides_enable_on_vim_startup=1
    let g:indent_guides_start_level=2
    let g:indent_guides_auto_colors=0
    let g:indent_guides_color_change_percent = 30
    let g:indent_guides_guide_size = 1

endif "}}}

if dein#tap('vim-operator-replace') "{{{

    " key_mappings {{{
    nmap s <Plug>(operator-replace)
    nmap S <Plug>(operator-replace)$
    "}}}

endif "}}}

if dein#tap('vim-operator-surround') "{{{

    " key_mappings {{{
    nmap <silent>ys <Plug>(operator-surround-append)
    nmap <silent>ds <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
    nmap <silent>cs <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
    "}}}

endif "}}}

if dein#tap('sideways.vim') "{{{

    " key_mappings {{{
    nnoremap <silent><c-h> :<C-u>SidewaysJumpLeft<cr>
    nnoremap <silent><c-l> :<C-u>SidewaysJumpRight<cr>
    "}}}

endif "}}}

if dein#tap('vim-table-mode') "{{{

endif "}}}

if dein#tap('open-browser.vim') "{{{

endif "}}}

if dein#tap('vim-gothrough-jk') "{{{

endif "}}}

if dein#tap('evervim') "{{{

    let g:evervim_devtoken="S=s301:U=2974e26:E=15901eda381:C=151aa3c76a0:P=1cd:A=en-devtoken:V=2:H=5fa185eb79a527ff40b094679f07657c"

endif "}}}

if dein#tap('foldCC.vim') "{{{

    set foldtext=FoldCCtext()
    set foldcolumn=3
    set fillchars=vert:\|
    let s:space = ''
    let g:foldCCtext_tail = 'printf("{%4d lines Lv%-2d}", v:foldend-v:foldstart+1, v:foldlevel)'
    let g:foldCCtext_head = ''

endif "}}}

if dein#tap('vim-operator-flashy') "{{{

    " key_mappings {{{
    map y <Plug>(operator-flashy)
    nmap Y <Plug>(operator-flashy)$
    "}}}

endif "}}}

if dein#tap('vim-go') "{{{

    let g:go_def_mapping_enabled = 0
    let g:go_doc_keywordprg_enabled = 0

    " key_mappings {{{
    autocmd vimrc filetype go Nnoremap <SID>[plugin]go <SID>[go]
    autocmd vimrc filetype go nmap     <SID>[go]r      <Plug>(go-run)
    autocmd vimrc FileType go nmap     <SID>[go]b      <Plug>(go-build)
    autocmd vimrc FileType go nmap     <SID>[go]t      <Plug>(go-test)
    autocmd vimrc FileType go nmap     <SID>[go]c      <Plug>(go-coverage)
    "}}}

endif "}}}

if dein#tap('ag.vim') "{{{

    " key_mappings {{{
    Nnoremap <SID>[plugin]a <SID>[ag]
    nmap     <SID>[ag]a     :Ag <c-r>=expand("<cword>")<cr><cr>
    nnoremap <space>/  :Ag
    "}}}

endif "}}}

if dein#tap('vim-expand-region') "{{{

    " key_mappings {{{
    vmap v     <Plug>(expand_region_expand)
    vmap <C-v> <Plug>(expand_region_shrink)
    "}}}

endif "}}}

if dein#tap('googlesuggest-complete-vim') "{{{

    set completefunc=googlesuggest#Complete

endif "}}}

if dein#tap('vim-ref') "{{{

    " key_mappings {{{
    Nnoremap <SID>[plugin]d <SID>[vim-ref]
    nmap     <SID>[vim-ref]d <Plug>(ref-keyword)
    nnoremap <SID>[vim-ref]h :<C-u>help
    "}}}

endif "}}}

if dein#tap('vim-ps1') "{{{

    let g:ps1_nofold_blocks = 1
    let g:ps1_nofold_sig = 1

endif "}}}

if dein#tap('nextfile.vim') "{{{

    nmap [ <Plug>(nextfile-next)
    nmap ] <Plug>(nextfile-previous)

endif "}}}

if dein#tap('vim-latex') "{{{

    set shellslash
    set grepprg=grep\ -nH\ $*
    let g:tex_flavor='latex'
    let g:Imap_UsePlaceHolders = 1
    let g:Imap_DeleteEmptyPlaceHolders = 1
    let g:Imap_StickyPlaceHolders = 0
    let g:Tex_DefaultTargetFormat = 'pdf'
    let g:Tex_MultipleCompileFormats='dvi,pdf'
    "let g:Tex_FormatDependency_pdf = 'pdf'
    let g:Tex_FormatDependency_pdf = 'dvi,pdf'
    "let g:Tex_FormatDependency_pdf = 'dvi,ps,pdf'
    let g:Tex_FormatDependency_ps = 'dvi,ps'
    let g:Tex_CompileRule_pdf = 'ptex2pdf -u -l -ot "-synctex=1 -interaction=nonstopmode -file-line-error-style" $*'
    "let g:Tex_CompileRule_pdf = 'pdflatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'
    "let g:Tex_CompileRule_pdf = 'lualatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'
    "let g:Tex_CompileRule_pdf = 'luajitlatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'
    "let g:Tex_CompileRule_pdf = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'
    "let g:Tex_CompileRule_pdf = 'ps2pdf $*.ps'
    let g:Tex_CompileRule_ps = 'dvips -Ppdf -o $*.ps $*.dvi'
    let g:Tex_CompileRule_dvi = 'uplatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'
    let g:Tex_BibtexFlavor = 'upbibtex'
    let g:Tex_MakeIndexFlavor = 'upmendex $*.idx'
    let g:Tex_UseEditorSettingInDVIViewer = 1
    let g:Tex_ViewRule_pdf = 'xdg-open'
    "let g:Tex_ViewRule_pdf = 'evince'
    "let g:Tex_ViewRule_pdf = 'okular --unique'
    "let g:Tex_ViewRule_pdf = 'zathura -x "vim --servername synctex -n --remote-silent +\%{line} \%{input}"'
    "let g:Tex_ViewRule_pdf = 'qpdfview --unique'
    "let g:Tex_ViewRule_pdf = 'texworks'
    "let g:Tex_ViewRule_pdf = 'mupdf'
    "let g:Tex_ViewRule_pdf = 'firefox -new-window'
    "let g:Tex_ViewRule_pdf = 'chromium --new-window'

endif "}}}

if dein#tap('rsense') "{{{

    let g:rsenseHome = '/usr/local/lib/rsense-0.3'
    let g:rsenseUseOmniFunc = 1

endif "}}}
