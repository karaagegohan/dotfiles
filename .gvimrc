" === Initialization ========================================================================================= {{{

if has('vim_starting')

    " window {{{
    set columns    =999   " width of window
    set lines      =999   " height of window
    " if has('gui_running')
    "     set fuoptions=maxvert,maxhorz
    "     augroup vim_window
    "         autocmd!
    "         " autocmd GUIEnter * set fullscreen 
    "     augroup END
    " endif
    " }}}

    " font {{{
    if has('win32')
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
    " }}}
    
endif

" }}}

" === window settings ======================================================================================== {{{

set columns    =999   " width of window
set lines      =999   " height of window

" if has('gui_running')
"     set fuoptions=maxvert,maxhorz
"     augroup vim_window
"         autocmd!
"         " autocmd GUIEnter * set fullscreen 
"     augroup END
" endif

" }}}

" === font settings ========================================================================================== {{{

if has('win32')
    set guifont        =MyricaM_M:h10:cSHIFTJIS
    set guifontwide    =MyricaM_M:h10:cSHIFTJIS
    set linespace      =1
    if has('kaoriya')
        set ambiwidth  =auto
    endif
elseif has('mac')
    set guifont        =Osaka-Mono:h15
elseif has('xfontset')
    set guifontset     =a10,r10,k10
endif

" }}}

" === base settings ========================================================================================== {{{

" mouse settings
set mouse=
set nomousefocus
set mousehide

" window settings
set guioptions =         " disable GUI options
set cmdheight  =2        " height of commandline

" colorscheme
" colorscheme Tomorrow-Night-Eighties
colorscheme gruvbox
set background =dark
" highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE
" highlight CursorLine gui=underline guifg=NONE guibg=NONE
if has('multi_byte_ime')
  highlight Cursor guifg=NONE guibg=White
  highlight CursorIM guifg=NONE guibg=Purple
endif

" cursol
set guicursor=n-v-c:hor10-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

" }}}

