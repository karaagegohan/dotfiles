on frontmost_app()
    tell application "System Events"
        set pList to name of every process whose frontmost is true
        set appName to item 1 of pList --"Script Editor"
        --set appName to name of (path to frontmost application)--"Script Editor.app"
    end tell
    --return appName--最後に評価された値が戻り値になるので不要
end frontmost_app

on run argv
    --デスクトッップのサイズを取得
    tell application "Finder"
        set menuHight       to 0
        set displayBounds   to bounds of window of desktop
        set displayPosition to {item 1 of displayBounds, (item 2 of displayBounds) + menuHight}
        set displaySize     to {item 3 of displayBounds, (item 4 of displayBounds) - menuHight}

        if item 1 of argv = "up" then
            set fixPosition     to displayPosition
            set fixSize         to {item 1 of displaySize, (item 2 of displaySize) / 2}

        else if item 1 of argv = "down" then
            set fixPosition     to {0, (item 2 of displaySize) / 2}
            set fixSize         to {item 1 of displaySize, (item 2 of displaySize) / 2}

        else if item 1 of argv = "left" then
            set fixPosition     to displayPosition
            set fixSize         to {(item 1 of displaySize) / 2, item 2 of displaySize}

        else if item 1 of argv = "right" then
            set fixPosition     to {(item 1 of displaySize) / 2, 0}
            set fixSize         to {(item 1 of displaySize) / 2, item 2 of displaySize}

        else if item 1 of argv = "max" then
            set fixPosition     to displayPosition
            set fixSize         to displaySize

        end if

    end tell

    set appName to frontmost_app()
    tell application "System Events"
        tell process appName			
            set topWindow to window 1
            set position of topWindow to fixPosition
            set size of topWindow to fixSize






end tell
    end tell
end run

