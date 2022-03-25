#!/bin/bash

# This script launches pause-console.rb with provided args.
# In macOS, the default terminal `Terminal.app` do not accept arguments.
# But, we can use AppleScript to pass arguments to it.
# Here we compose an AppleScript, then execute it with `oscascript`.
# The first part of this shell script is quoting and escaping quotes in args.
# (A quote in args should be like \\\\\\" in AppleScript. Damn it.)

escaped_args=()
for arg in "$@"; do
    quoted="\"${arg//\"/\\\"}\""
    quoted=${quoted//\\/\\\\}
    quoted=${quoted//\"/\\\"}
    escaped_args+=($quoted)
done

cwd=$(dirname "$BASH_SOURCE")
cwd="\"${cwd//\"/\\\"}\""
cwd=${cwd//\\/\\\\}
cwd=${cwd//\"/\\\"}

osascript > /dev/null <<EOF
tell application "Terminal"
    activate
    do script "cd ${cwd}; clear; ./pause-console.rb ${escaped_args[@]}; exit"
end tell
EOF
