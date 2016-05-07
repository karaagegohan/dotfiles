
for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    # echo "made symbolic link $f"
    echo "$HOME"/"$f"
    rm "$HOME"/"$f"
    ln -s "$HOME"/dotfiles/"$f" "$HOME"/"$f"
done
