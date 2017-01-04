" initialization {{{
augroup vimrc
  autocmd!
augroup END

if has('vim_starting')

  let env#mac  = has('mac')
  let env#win  = has('win32') || has('win64')
  let env#gui  = has('gui_running')
  let env#nvim = has('nvim')

  let g:python3_host_prog = expand('$HOME') . '/.pyenv/shims/python'

  " dein settings
  let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
  let s:dein_dir = s:cache_home . '/dein'
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
  endif
  let &runtimepath = s:dein_repo_dir .",". &runtimepath
  let s:toml_dir = expand('$HOME/.config/nvim/dein')
  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    let s:tomls = split(glob(s:toml_dir . "/*.toml"), "\n")
    for s:toml in s:tomls
      call dein#load_toml(s:toml,{'lazy': 0})
    endfor
    call dein#end()
    call dein#save_state()
  endif
  if dein#check_install()
    call dein#install()
  endif

  set encoding =utf-8           " Character code for .vimrc

endif
" }}}

" functions {{{

" *** NOTE[variable scope] *** {{{
" --------------------------------------------------
" | prefix      | scope                            |
" |:-----------:|:--------------------------------:|
" | let l:var1  | function local                   |
" | let a:var2  | function local (for parameters)  |
" | let s:var3  | script local                     |
" | let b:var4  | buffer local                     |
" | let w:var5  | window local                     |
" | let t:var6  | tab local                        |
" | let g:var7  | global                           |
" | let var8    | global                           |
" | let v:var9  | global (defined by vim)          |
" --------------------------------------------------
" }}}

function! s:mkdir(name) abort "{{{
  if !isdirectory(expand(a:name))
    call mkdir(expand(a:name))
  endif
endfunction
"}}}

function! s:transparancy_up() abort "{{{
  if env#gui
    if env#mac
      if &transparency - 5 > 1
        set transparency-=5
      else
        set transparency =0
      endif
    elseif env#win
      if &transparency - 5 > 1
        set transparency-=5
      else
        set transparency =1
      endif
    endif
  endif
endfunction
"}}}

function! s:transparancy_down() abort "{{{
  if env#gui
    if env#mac
      if &transparency + 5 < 100
        set transparency+=5
      else
        set transparency =100
      endif
    elseif env#win
      if &transparency + 5 < 255
        set transparency+=5
      else
        set transparency =255
      endif
    endif
  endif
endfunction
"}}}

function! s:fullscreen() abort "{{{
  if env#gui
    if env#mac
      set fullscreen!
    else
      set columns =999
      set lines   =999
    endif
  endif
endfunction
"}}}

function! s:toggleopt(optname) abort "{{{
  try
    exec( 'set ' . a:optname . '!')
    exec( 'echo  "[' . a:optname . ']" ' . '&' . a:optname . '==1 ? "on" : "off"')
  catch
    echo a:optname . " does not exist."
  endtry
endfunction
"}}}

function! s:close_window() abort "{{{
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

function! s:rm_swp() abort "{{{
  let a:currentfile = fnamemodify(expand('%'), ":t")
  let a:directory = &directory
  echo a:directory
  exec '!rm ' . a:directory . '/' . a:currentfile . '.sw*'
endfunction "}}}

function! s:set_indent_options(num) "{{{
  exec('setlocal tabstop=' . a:num)
  exec('setlocal softtabstop=' . a:num)
  exec('setlocal shiftwidth=' . a:num)
endfun "}}}

function! s:anoremap(lhs, rhs) "{{{
  exec( 'noremap '  . a:lhs . ' ' . a:rhs )
  exec( 'noremap! ' . a:lhs . ' ' . a:rhs )
  exec( 'lnoremap ' . a:lhs . ' ' . a:rhs )
endfun "}}}

function! s:swap_num_key() "{{{
  let g:ynoca_swap_keys = exists('g:ynoca_swap_keys') ? !g:ynoca_swap_keys : 1
  let a:keys = [
      \    ['1', "!"],
      \    ['2', "@"],
      \    ['3', "#"],
      \    ['4', "$"],
      \    ['5', "%"],
      \    ['6', "^"],
      \    ['7', "&"],
      \    ['8', "*"],
      \    ['9', "("],
      \    ['0', ")"]
      \    ]
  if g:ynoca_swap_keys
    for a:k in a:keys
      call s:anoremap(a:k[0], a:k[1])
      call s:anoremap(a:k[1], a:k[0])
    endfor
  else
    for a:k in a:keys
      call s:anoremap(a:k[0], a:k[0])
      call s:anoremap(a:k[1], a:k[1])
    endfor
  endif
endfun "}}}

function! s:char_code() "{{{
  if winwidth('.') <= 70
    echo  ''
  endif

  " Get the output of :ascii
  redir => ascii
  silent! ascii
  redir END

  if match(ascii, 'NUL') != -1
    echo  'NUL'
  endif

  " Zero pad hex values
  let s:nrformat = '0x%02x'

  let encoding = (&fenc == '' ? &enc : &fenc)

  if encoding == 'utf-8'
    " Zero pad with 4 zeroes in unicode files
    let s:nrformat = '0x%04x'
  endif

  " Get the character and the numeric value from the echo  value of :ascii
  " This matches the two first pieces of the echo  value, e.g.
  " "<F>  70" => char: 'F', nr: '70'
  let [s:str, s:char, s:nr; s:rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')

  " Format the numeric value
  let s:nr = printf(s:nrformat, s:nr)

  echo  "'". s:char ."' ". s:nr
endfunction "}}}

function! s:save_with_date() "{{{
  let s:filename = strftime("%Y%m%d") . '.txt'
  exec ( 'write ' . s:filename )
endfunction "}}}

function! init#open_next_file(next) "{{{
  function! s:file_pass_filter(files)
    let l:ret = []
    for l:file  in a:files
      if !isdirectory(l:file)
        call add(l:ret, l:file)
      endif
    endfor
    return l:ret
  endfunction
  let l:current_file = expand('%:p') 
  let l:files = s:file_pass_filter(split(glob(expand('%:p:h') . "/*"), "\n"))
  if len(l:files) <= 1
    return
  endif
  let l:cnt = match(l:files, l:current_file)
  if a:next == "next"
    execute("edit " . l:files[(l:cnt + 1) % len(l:files)])
  elseif a:next == "prev"
    execute("edit " . l:files[(l:cnt - 1) % len(l:files)])
  endif
endfunction "}}}

"}}}

" key mappings {{{

" *** NOTE[map command] *** {{{
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
nnoremap <SID>[command]          <Nop>
nmap     ,                       <SID>[command]

" basic
noremap  ;                       :
noremap! ;                       :
lnoremap ;                       :
noremap  :                       @:
lnoremap :                       ;
noremap! :                       ;
noremap  <C-c>                   <Esc>
noremap! <C-c>                   <Esc>
lnoremap <C-c>                   <Esc>
nnoremap <CR>                    :<C-u>write<CR>
nnoremap <S-CR>                  :<C-u>write!<CR>
nnoremap U                       <C-r>
cnoremap <C-c>                   :<C-u><Esc>
nnoremap <silent><C-c><C-c>      :<C-u>nohlsearch<CR>
inoremap jj                      <Esc>
inoremap kk                      <CR>
nnoremap <C-h>                   <Nop>
nnoremap <C-j>                   <Nop>
nnoremap <C-k>                   <Nop>
nnoremap <C-l>                   <Nop>

" edit
nnoremap Y                       y$
nnoremap R                       J
nnoremap x                       "_x
nnoremap X                       x
vnoremap >                       >gv
vnoremap <                       <gv

" cursor
nnoremap j                       gj
nnoremap k                       gk
vnoremap j                       gj
vnoremap k                       gk
noremap  H                       ^
noremap  J                       }
noremap  K                       {
noremap  L                       $

" searching
nnoremap n                       nzO
nnoremap N                       NzO
nnoremap '                       *NzO
nnoremap "                       #NzO

" window
nnoremap gh                      <C-w>h
nnoremap gj                      <C-w>j
nnoremap gk                      <C-w>k
nnoremap gl                      <C-w>l
nnoremap <silent><SID>[command]n :<C-u>new<CR>
nnoremap <silent><SID>[command]v :<C-u>vnew<CR>
nnoremap <silent><SID>[command]N :<C-u>split<CR>
nnoremap <silent><SID>[command]V :<C-u>vsplit<CR>
nnoremap <S-Left>                <C-w><<CR>
nnoremap <S-Right>               <C-w>><CR>
nnoremap <S-Up>                  <C-w>-<CR>
nnoremap <S-Down>                <C-w>+<CR>
nnoremap <Left>                  <C-w>L<CR>
nnoremap <Right>                 <C-w>H<CR>
nnoremap <Up>                    <C-w>-<CR>
nnoremap <Down>                  <C-w>+<CR>
nnoremap <silent><BS>            :<C-u>bdelete<CR>
nnoremap <silent><BS>            :<C-u>bdelete<CR>

" tab
nnoremap <TAB>                   gt
nnoremap <S-TAB>                 gT
nnoremap <SID>[command]t         :<C-u>tabnew<CR>

" buffer
nnoremap <silent>(               :<C-u>call init#open_next_file("next")<CR>
nnoremap <silent>)               :<C-u>call init#open_next_file("prev")<CR>
nnoremap <silent><SID>[command]b :<C-u>enew<CR>

" command mode
cnoremap <C-n>                   <DOWN>
cnoremap <C-p>                   <UP>

" fold
nnoremap zz                      za

" toggle
nnoremap <silent><SID>[command]1 :<C-u>ToggleOpt number<CR>
nnoremap <silent><SID>[command]2 :<C-u>ToggleOpt relativenumber<CR>
nnoremap <silent><SID>[command]3 :<C-u>ToggleOpt autochdir<CR>
nnoremap <silent><SID>[command]4 :<C-u>ToggleOpt list<CR>
nnoremap <silent><SID>[command]5 :<C-u>ToggleOpt foldenable<CR>
nnoremap <silent><SID>[command]6 <Nop>
nnoremap <silent><SID>[command]7 <Nop>
nnoremap <silent><SID>[command]8 <Nop>
nnoremap <silent><SID>[command]9 <Nop>

" function keys
nnoremap <silent><F1>            <Nop>
nnoremap <silent><F2>            <Nop>
nnoremap <silent><F3>            <Nop>
nnoremap <silent><F4>            <Nop>
nnoremap <silent><F5>            <Nop>
nnoremap <silent><F6>            <Nop>
nnoremap <silent><F7>            <Nop>
nnoremap <silent><F8>            <Nop>
nnoremap <silent><F9>            <Nop>
nnoremap <silent><F10>           <Nop>
nnoremap <silent><F11>           <Nop>
nnoremap <silent><F12>           <Nop>

" other
nnoremap <silent><SID>[command].  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent><SID>[command],  :<C-u>edit ~/dotfiles/.config/nvim/dein/basic.toml<CR>
nnoremap <silent><SID>[command]r  :<C-u>source $MYVIMRC<CR>:<C-u>echo expand($MYVIMRC) . " has loaded."<CR>
nnoremap <silent><SID>[command]f  :<C-u>source %<CR>:<C-u>echo expand("%") . " has loaded."<CR>
nnoremap <silent><SID>[command]h  :<C-u>help <C-r><C-w><CR>
nnoremap <silent><SID>[command]e  :<C-u>edit<CR>
nnoremap <silent><SID>[command]c  q:
nnoremap <silent><SID>[command]x  :<C-u>exit<CR>
nnoremap         <SID>[command]sa :<C-u>%s///g<LEFT><LEFT>
nnoremap         <SID>[command]sp :<C-u>%s///gc<LEFT><LEFT><LEFT>

" terminal for nvim
if env#nvim
  tnoremap <silent>jj       <C-\><C-n>
  nnoremap <SID>[command]zz :<C-u>terminal<CR>
  nnoremap <SID>[command]zv :<C-u>vnew<CR>:<C-u>terminal<CR>
  nnoremap <SID>[command]zn :<C-u>new<CR>:<C-u>terminal<CR>
endif

" set filetypes
nnoremap <SID>[setft] <Nop>
nmap     <SID>[command]sf <SID>[setft]
nnoremap <silent><SID>[setft]r :<C-u>setlocal filetype=ruby<CR>
nnoremap <silent><SID>[setft]g :<C-u>setlocal filetype=go<CR>
nnoremap <silent><SID>[setft]v :<C-u>setlocal filetype=vim<CR>
nnoremap         <SID>[setft]f :<C-u>setlocal filetype=

"}}}

" options {{{

" encoding
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
if env#win
  let &termencoding = &encoding
endif

" indent
filetype indent  on
filetype plugin  on
set backspace         =indent,eol,start    " More powerful backspacing
set smartindent                            " Indent automatically
set autoindent                             " Indent automatically
set shiftwidth        =2                   " Width of indent for autoindent
set tabstop           =2                   " Width of TAB
set softtabstop       =2
set expandtab                              " Change TAB to space
set textwidth         =0                   " Text width
set whichwrap         =b,s,h,l,<,>,[,]     " Release limit of cursor
set shiftround
let g:vim_indent_cont =4                   " Space before \

" modeline
set modeline
set modelines =3

" statusline
set laststatus=2

" function
set history  =1024   " Number of history
set helplang =en     " Language to read help

" view
syntax on                     " Show syntax hilight
set number                    " Show line number
set ruler                     " Show current line number
set title                     " Show title of the file

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
set completeopt   =menu
set splitbelow
set hidden
set nocursorline
set ambiwidth     =single
set updatetime    =250
set shortmess    +=I

" edit
set switchbuf =useopen   " use an existing buffer instaed of creating a new one
set iminsert  =1
set imsearch  =-1

" searching
set incsearch   " Disable increment search
set wrapscan    " Searchrs wrap around
set ignorecase

" command line
set timeoutlen =2000      " time to wait for a key code

" action
set autoread                    " reload file automatically when it is updated
set scrolloff      =10          " scrooloff
set sidescroll     =1           " unit of left and right scroll
set sidescrolloff  =8           " scrooloff
set clipboard     +=unnamed     " sharing system clipboard
set clipboard     +=unnamedplus " sharing system clipboard
set nrformats      =            " incrementing and decrementing mode
set autochdir                   " change automatically the current working directory

" fold
set foldenable            " enable fold
set foldcolumn  =0        " width of folding guide
set foldmethod  =marker   " folding by {{{,}}}

" directories
set browsedir  =current

" backup file
set backup
if &backup
  let s:backupdir = expand('~/.vim/bak')
  call s:mkdir(s:backupdir)
  let &backupdir = s:backupdir
endif

" undo file
set undofile
if &undofile
  let s:undodir = expand('~/.vim/undo')
  call s:mkdir(s:undodir)
  let &undodir = s:undodir
endif

" swap file
set noswapfile
if &swapfile
  let s:swapdir = expand('~/.vim/swp')
  call s:mkdir(s:swapdir)
  let &directory = s:swapdir
endif

" mouse
set mouse=
set nomousefocus
set mousehide

" gui
if env#gui "{{{

  if has('vim_starting')

    " window
    set columns    =999   " width of window
    set lines      =999   " height of window

    " font
    if env#win
      set guifont        =Inconsolata:h13:cANSI
      set guifontwide    =Ricty_Diminished:h13:cSHIFTJIS
      set linespace      =1
      if has('kaoriya')
        set ambiwidth  =auto
      endif
    elseif has('mac')
      set guifont        =Osaka-Mono:h13
    elseif has('xfontset')
      set guifontset     =a13,r13,k13
    endif

  endif

  " window settings
  set guioptions =         " disable GUI options
  set cmdheight  =2        " height of commandline

  " colorscheme
  if has('multi_byte_ime')
    highlight Cursor guifg=NONE guibg=White
    highlight CursorIM guifg=NONE guibg=Purple
  endif

  " cursol
  set guicursor=n-v-c:hor10-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

end "}}}

" nvim
if env#nvim "{{{
  autocmd vimrc BufEnter * if &buftype == 'terminal' | startinsert | endif
  autocmd vimrc BufEnter * if &buftype == 'terminal' | nnoremap <buffer><BS> <Nop> | endif
  autocmd vimrc BufEnter * if &buftype == 'terminal' | nnoremap <silent><buffer><BS> :<C-u>quit!<CR> | endif
endif "}}}

"}}}

" autocmds {{{

" filetype
autocmd vimrc BufRead, FileType               help  setlocal nofoldenable
autocmd vimrc BufRead, BufNewFile *.ahk       setlocal fileencoding=sjis
autocmd vimrc BufRead, BufNewFile *.xm        setlocal filetype=objc
autocmd Filetype python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab

" }}}

