#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
xfce4-terminal -e $SCRIPT_DIR/pause-console.sh "$@"
