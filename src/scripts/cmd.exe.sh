#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cmd.exe /C START wsl.exe -d $WSL_DISTRO_NAME --user $LOGNAME -- $SCRIPT_DIR/pause-console.sh "$@"
