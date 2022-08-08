#!/bin/bash

clear
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <Executable> [<Arguments...>]"
  exit
fi
function set_title() {
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}
set_title $1
start_time="$(date -u +%s.%4N)"
"$1" "${@:2}"
exit_code=$?
end_time="$(date -u +%s.%4N)"

exit_code_str=" 返回值 ${exit_code} "
time_str=" 用时 $(echo "$end_time-$start_time" | bc | sed 's/^\./0./')s "
hint_width=$((${#time_str} + ${#exit_code_str} + 7)) # 5 CJK character and 2 Powerline Glyphs
len=$((($(tput cols) - $hint_width) / 2))
dots=$(printf '·%.0s' $(seq 1 $len))
GRAY='\033[38;5;242m'
RESET='\033[0m'
BG_RED='\033[41m'
BG_GREEN='\033[42m' 
BG_YELLOW_FG_BLACK='\033[43;30m'
FG_RED='\033[0;31m'
FG_GREEN='\033[0;32m'
FG_YELLOW='\033[0;33m'
# PowerLine Glyphs < and >
GT='\ue0b0'
LT='\ue0b2'

echo
echo -e -n "${GRAY}${dots}${RESET}"

if [[ exit_code -eq 0 ]]; then
    exit_fg_color=$FG_GREEN
    exit_bg_color=$BG_GREEN
else
    exit_fg_color=$FG_RED
    exit_bg_color=$BG_RED
fi
echo -e -n "${exit_fg_color}${LT}${RESET}"
echo -e -n "${exit_bg_color}${exit_code_str}${RESET}"
echo -e -n "${BG_YELLOW_FG_BLACK}${time_str}${RESET}"
echo -e -n "${FG_YELLOW}${GT}${RESET}"
echo -e "${GRAY}${dots}"
read -n 1 -s -r -p "进程已结束。按任意键关闭窗口..."
echo -e -n "${RESET}"
