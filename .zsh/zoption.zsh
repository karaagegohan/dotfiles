# history 

# do not enter command lines into the history list if they are duplicates of the previous event
setopt HIST_IGNORE_DUPS
# when a new duplicated command is added, the older command is removed from the list
setopt HIST_IGNORE_ALL_DUPS
# remove command lines from the history list when the first character on the line is a space
setopt HIST_IGNORE_SPACE
# do not display duplicates of a line previously found
setopt HIST_FIND_NO_DUPS
# remove superfluous blanks from each command line
setopt HIST_REDUCE_BLANKS
# do not store history command
setopt HIST_NO_STORE
# save date with command line
setopt EXTENDED_HISTORY
# a file to save history
HISTFILE=$HOME/.zsh_history
# a number of history saved in the memory
HISTSIZE=1000000
# a number of history saved in $HISTORY
SAVEHIST=1000000

# command line

# enable zmv command
autoload -Uz zmv
# enable comment symbol in command line
setopt interactivecomments

