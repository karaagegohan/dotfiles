tell application "System Events"
    set appList to name of every application process whose visible is true
    set frontApp to name of every application process whose frontmost is true
    log frontApp
    log appList
end tell

