#!/user/bin/osascript

-- 尚未测试，Apple 有够烦

on list2string(list, delim)
  set backup to AppleScript's text item delimiters
  set AppleScript's text item delimiters to delim
  set result to list as string
  set AppleScript's text item delimiters to backup
  return result
end list2string

on run argv
  set scriptArgv to list2string(quoted form of every argv, " ")
  tell application "Terminal"
    activate
    
    -- 忙等，不好
    -- set newTab do script (path to me) & "/pause-console.rb " & scriptArgv & "; exit"
    -- delay 1
    -- repeat while newTab exists
    --   delay 1
    -- end repeat
    -- close

    -- 是否有类似这样的操作？不清楚
    -- tell window 1
    --   do script (path to me) & "/pause-console.rb" & scriptArgv & "; exit"
    --   set shell exit action to 0
    -- end tell
  end tell
end run
