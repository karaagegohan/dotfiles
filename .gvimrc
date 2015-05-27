" === Initialization ========================================================================================= {{{

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
    set columns    =160   " width of window
    set lines      =140   " height of window
endif

" }}}

" === font settings =========================================================================================== {{{

if has('win32')
    " set guifont=Meslo_LG_S_DZ:h12:cANSI
    set guifont      =Inconsolata:h10:cANSI
    set guifontwide  =Ricty_Diminished:h10:cSHIFTJIS
    " set guifont=Inconsolata:h18:cANSI
    " set guifontwide=Ricty_Diminished:h18:cSHIFTJIS
    " 行間隔の設定
    set linespace=1
    " 一部のUCS文字の幅を自動計測して決める

    if has('kaoriya')
        set ambiwidth=auto
    endif
elseif has('mac')
    set guifont=Osaka-Mono:h16
elseif has('xfontset')
    " UNIX用 (xfontsetを使用)
    set guifontset=a14,r14,k14
endif

" }}}

" === input settings ========================================================================================== {{{

if has('multi_byte_ime') || has('xim')
    " IME ON時のカーソルの色を設定(設定例:紫)
    highlight CursorIM guibg=Purple guifg=NONE
    " 挿入モード・検索モードでのデフォルトのIME状態設定
    set iminsert=0 imsearch=0
    if has('xim') && has('GUI_GTK')
        " XIMの入力開始キーを設定:
        " 下記の s-space はShift+Spaceの意味でkinput2+canna用設定
        "set imactivatekey=s-space
    endif
    " 挿入モードでのIME状態を記憶させない場合、次行のコメントを解除
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

"colorscheme
colorscheme jellybeans   " colorsheme

" }}}
