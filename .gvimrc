if has('vim_starting')

  " window
  set columns    =999   " width of window
  set lines      =999   " height of window

  " font
  if has('win32') || has('win64')
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

endif
