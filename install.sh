#...

DOTPATH=~/dotfiles
GITHUB_URL=https://github.com/ynoca/dotfiles

# git が使えるなら git
if which "git"; then
    git clone --recursive "$GITHUB_URL" "$DOTPATH"

# # 使えない場合は curl か wget を使用する
# elif which "curl" || has "wget"; then
#     tarball=GITHUB_URL"/archive/master.tar.gz"
#     
#     # どっちかでダウンロードして，tar に流す
#     if which "curl"; then
#         curl -L "$tarball"
#
#     elif which "wget"; then
#         wget -O - "$tarball"
#
#     fi | tar xv -
#     
#     # 解凍したら，DOTPATH に置く
#     mv -f dotfiles-master "$DOTPATH"

else
    die "curl or wget required"
fi

cd $DOTPATH
if [ $? -ne 0 ]; then
    die "not found: $DOTPATH"
fi
for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    # echo "made symbolic link $f"
    echo "$HOME"/"$f"
    rm "$HOME"/"$f"
    ln -s "$HOME"/dotfiles/"$f" "$HOME"/"$f"
done

ln -s "$HOME"/dotfiles/bin "$HOME"/bin
