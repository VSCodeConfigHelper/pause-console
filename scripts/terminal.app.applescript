#!/usr/bin/osascript

on make_cmdline(argv)
	set quoted_argv to {}
	repeat with arg in argv
		set end of quoted_argv to quoted form of arg
	end repeat
	
	set text item delimiters to " "
	set args to quoted_argv as string
	
	set filepath to POSIX path of ((path to me as text) & "::")
	
	return filepath & "pause-console.rb " & args & "; exit"
end make_cmdline

on run argv
	set cmdline to make_cmdline(argv)
	tell application "Terminal"
		activate
		
		set new_tab to do script cmdline
		set targeted_window to first window of (every window whose tabs contains new_tab)
		delay 1
    
		if (system attribute "PAUSE_CONSOLE_WAIT_AND_CLOSE") is not "" then
			repeat while busy of new_tab
				delay 1
			end repeat
			close targeted_window
		end if
	end tell
end run
