export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export LSCOLORS=exfxcxdxbxegedabagacad

local DEFAULT=%{$reset_color%}
local RED=$fg[red]
local GREEN=$fg[green]
local YELLOW=$fg[yellow]
local BLUE=$fg[blue]
local PURPLE=$fg[purple]
local MAGENTA=$fg[magenta]
local WHITE=$fg[white]

setopt correct
# setopt list_types 

zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:default' menu select=2


