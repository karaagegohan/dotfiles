" === Initialization ========================================================================================= {{{

if has('vim_starting')

    set columns    =80    " width of window
    set lines      =140   " height of window

    " window
    if has('gui_macvim')
        set fuoptions=maxvert,maxhorz
        augroup vim_window
            autocmd!
            " autocmd GUIEnter * set fullscreen 
        augroup END
    endif

endif

" }}}

" === font settings =========================================================================================== {{{

if has('win32')
    set guifont      =Inconsolata:h10:cANSI
    set guifontwide  =Ricty_Diminished:h10:cSHIFTJIS
    set linespace=1
    if has('kaoriya')
        set ambiwidth=auto
    endif
elseif has('mac')
    set guifont=Osaka-Mono:h16
elseif has('xfontset')
    set guifontset=a14,r14,k14
endif

" }}}

" === input settings ========================================================================================== {{{

if has('multi_byte_ime') || has('xim')
    highlight CursorIM guibg=Purple guifg=NONE
    set iminsert=0 imsearch=0
    if has('xim') && has('GUI_GTK')
        "set imactivatekey=s-space
    endif
    inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

" }}}

" === base settings ========================================================================================= {{{

" mouse settings
set mouse=
set nomousefocus
set mousehide

" window settings
set guioptions =         " invalidate GUI options
set cmdheight  =1        " height of commandline

" colorscheme
colorscheme jellybeans   " colorsheme

" }}}

