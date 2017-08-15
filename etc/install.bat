@echo off
for /d %%a in (../.*) do (
    rm -rf %HOME%\%%a 
    mklink /d %HOME%\%%a %HOME%\dotfiles\%%a
)
for %%a in (../.*) do (
    rm -rf %HOME%\%%a 
    mklink %HOME%\%%a %HOME%\dotfiles\%%a
)
