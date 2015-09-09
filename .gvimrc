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
    "
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
    set guifont        =Osaka-Mono:h10
elseif has('xfontset')
    set guifontset     =a10,r10,k10
endif

" }}}

" === input settings ========================================================================================= {{{

if has('multi_byte_ime') || has('xim')
    highlight CursorIM guibg=Purple guifg=NONE
    set iminsert=0 imsearch=0
    if has('xim') && has('GUI_GTK')
        "set imactivatekey=s-space
    endif
    inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
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
let g:gruvbox_italic = 0
colorscheme gruvbox   " colorsheme
set background =dark

" }}}

