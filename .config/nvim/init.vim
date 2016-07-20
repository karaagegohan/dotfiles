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
nnoremap <SID>[func]        <Nop>
nmap     ,                  <SID>[func]

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
if has('nvim')
    nnoremap <silent><SID>[func],    :<C-u>edit ~/dotfiles/.config/nvim/dein.toml<CR>
else
    nnoremap <silent><SID>[func],    :<C-u>edit $MYGVIMRC<CR>
endif
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
syntax on

" modeline
set modeline
set modelines =3

" statusline
set laststatus=2

" function
set history  =1024   " Number of history
set helplang =en     " Language to read help

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
set updatetime    =250

" indent
set backspace         =indent,eol,start    " More powerful backspacing
set smartindent                            " Indent automatically
set autoindent                             " Indent automatically
set shiftwidth        =4                   " Width of indent for autoindent
set tabstop           =4                   " Width of TAB
set softtabstop       =4
set expandtab                              " Change TAB to space
set textwidth         =0                   " Text width
set whichwrap         =b,s,h,l,<,>,[,]     " Release limit of cursor
let g:vim_indent_cont =4                   " Space before \

autocmd vimrc BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2

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

autocmd vimrc BufRead, FileType help setlocal nofoldenable
autocmd vimrc BufRead, BufNewFile *.ahk setlocal fileencoding=sjis

"}}}

