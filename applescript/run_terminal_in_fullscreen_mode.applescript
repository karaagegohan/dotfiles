tell application "Terminal"
	activate
	tell application "System Events"
		tell process "Terminal"
			click menu item "Enter Full Screen" of menu 1 of menu bar item "View" of menu bar 1
		end tell
	end tell
end tell
