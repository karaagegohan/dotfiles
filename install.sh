DOTPATH=$HOME/dotfiles
GITHUB_URL=https://github.com/ynoca/dotfiles

files=()
get_final_file()
{
    for f in $1/* 
    do
        [[ $f == .git ]] && continue
        [[ $f == .DS_Store ]] && continue

        # [[ -f $f || -d $f ]] && rm -r $HOME/$f
        # ln -s -i $DOTPATH/$f $HOME/$f
        # echo $DOTPATH/$f
        if [ -d $f ]; then
            if [ -z "`ls $f`" ]; then
            files+= $f
            else
                get_final_file $f 
            fi
        else
            files+=($f)
        fi
        # fi
        # echo [ln] $DOTPATH/$f '\t->' $HOME/$f
    done
}

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

    if [ -f $f ]; then
        ln -s -f $DOTPATH/$f $HOME/$f
        echo [ln] $DOTPATH/$f '\t->' $HOME/$f
    elif [ -d $f ]; then
        get_final_file .config
        for ff in ${files[@]}
        do
            if [[ $ff =~ (.+)/.+ ]]; then
                echo mkdir -p $HOME/${BASH_REMATCH[1]}
            fi
            ln -s -f $DOTPATH/$ff $HOME/$ff
            echo [ln] $DOTPATH/$ff '\t->' $HOME/$ff
        done
    fi
done

