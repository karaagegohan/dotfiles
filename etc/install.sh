DOTPATH=$HOME/dotfiles
GITHUB_URL=https://github.com/ynoca/dotfiles

# use git if you has it
echo [git] Cloning $GITHUB_URL.
if [ `which git` ]; then
    if [ -d $DOTPATH ]; then
        echo [git] $DOTPATH already exisis.
    else
        git clone --recursive "$GITHUB_URL" "$DOTPATH" > /dev/null 2>&1
    fi
else
    echo [git] git command not found
    echo [git] curl or wget required
fi

# change directory
cd $DOTPATH
if [ $? -ne 0 ]; then
    echo "not found: $DOTPATH"
fi

# make symbolic links of each dotfile under home directory
echo [ln] make symbolic links of each dotfile under home directory
for f in .??*
do
    [[ $f == .git ]] && continue
    [[ $f == .DS_Store ]] && continue

    ln -sfn $DOTPATH/$f $HOME/$f
    echo [ln] $DOTPATH/$f '\t->' $HOME/$f

done

# make symbolic links of each folder
echo [ln] make symbolic links of each folder
for f in *
do
    if [ -d $f ]; then
        ln -sfn $DOTPATH/$f $HOME/$f
        echo [ln] $DOTPATH/$f '\t->' $HOME/$f
    fi
done
