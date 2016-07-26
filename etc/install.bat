@echo off
for /d %%a in (../.*) do (
    rm -rf %HOME%\%%a 
    mklink /d %HOME%\%%a %HOME%\dotfiles\%%a
)
for %%a in (../.*) do (
    rm -rf %HOME%\%%a 
    mklink %HOME%\%%a %HOME%\dotfiles\%%a
)
rm -rf %HOME%\.vimrc 
mklink %HOME%\.vimrc %HOME%\dotfiles\.config\nvim\init.vim
