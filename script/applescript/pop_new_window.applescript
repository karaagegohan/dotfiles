tell application "Google Chrome"
    set frontIndex to active tab index of front window
    set sURL to get URL of tab frontIndex of front window
    close active tab of window 1
    make new window
    activate
    open location sURL
end tell
