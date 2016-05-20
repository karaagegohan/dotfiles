tell application "System Events"
    try
        tell front window of (first process whose frontmost is true)
            set isFullScreen to get value of attribute "AXFullScreen"
            set isFullScreenAfter to not isFullScreen
            set value of attribute "AXFullScreen" to isFullScreenAfter
        end tell
    end try
end tell
