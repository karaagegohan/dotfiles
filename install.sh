DOTPATH=$HOME/dotfiles
GITHUB_URL=https://github.com/ynoca/dotfiles

#files and folders excepting dotfiles
others=()
others+=(init.vim,$HOME/.config/nvim/init.vim)
others+=(dein.toml,$HOME/.config/nvim/dein.toml)
others+=(bin,$HOME/bin)
others+=(applescript,$HOME/applescript)

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

    [[ -f $f || -d $f ]] && rm -r $HOME/$f
    ln -s $DOTPATH/$f $HOME/$f
    echo [ln] $DOTPATH/$f '\t->' $HOME/$f
done

# make symbolic links of other files
for f in *
do
    for o in ${others[@]}
    do
        arr=( `echo $o | tr -s ',' ' '`)
        if [ $f = ${arr[0]} ]; then 
            [[ -f ${arr[1]} ]] && rm ${arr[1]}
            if [ -d ${arr[1]} ]; then
                rm -r ${arr[1]}
            else
                mkdir -p ${arr[1]}
                rm -r ${arr[1]}
            fi
            ln -s $DOTPATH/${arr[0]} ${arr[1]} 
            echo [ln] $DOTPATH/${arr[0]} '\t->' ${arr[1]} 
        fi
    done
done
