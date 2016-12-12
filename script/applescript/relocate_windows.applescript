on active_windows()
  tell application "System Events"
      set procs to (application processes where visible is true)
      set wins to (first attribute whose name is "AXWindows") of 
      (*      wi to wi & (value of (first attribute whose name is "AXWindows") of theProcess)    *)
      (*   if first atribute of theProcess = "AXWindows" then *)
      (*     log "asdf" *)
      (*   end if *)
      (* end repeat *)
      (* wi *)
  end tell
end active_windows

on run argv
  repeat with win in active_windows()
    tell win
      (* set position of win to {0,0} *)
    end tell
  end repeat
end run
