#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
xterm -e $SCRIPT_DIR/pause-console.sh "$@"
