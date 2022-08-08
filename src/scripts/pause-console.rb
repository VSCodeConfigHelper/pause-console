#!/usr/bin/ruby

require 'io/console'

puts "\e[H\e[2J" # Clear console
if ARGV.length == 0 then
  puts "Usage: #{__FILE__} <Executable> [<Arguments...>]"
  exit
end

command_line = ARGV.map { |arg| %|"#{arg.gsub('"', '\"')}"| } .join(' ')
start_time = Time.now
system("#{command_line}")
exit_code = $?.exitstatus
end_time = Time.now

exit_code_str = " 返回值 #{exit_code} "
elapsed_time = "%.4f" % (end_time - start_time)
time_str = " 用时 #{elapsed_time}s "
hint_width = time_str.length + time_str.length + 2 # 5 CJK character and 2 Powerline Glyphs
term_width = IO.console.winsize[1]
dots = "·" * ((term_width - hint_width) / 2).floor
GRAY="\e[38;5;242m"
RESET = "\e[0m"
BG_RED = "\e[41m"
BG_GREEN = "\e[42m" 
BG_YELLOW_FG_BLACK = "\e[43;30m"
FG_RED = "\e[0;31m"
FG_GREEN = "\e[0;32m"
FG_YELLOW = "\e[0;33m"
# PowerLine Glyphs < and >
GT="\ue0b0"
LT="\ue0b2"
if exit_code == 0 then
    exit_fg_color = FG_GREEN
    exit_bg_color = BG_GREEN
else
    exit_fg_color = FG_RED
    exit_bg_color = BG_RED
end

puts
print "#{GRAY}#{dots}#{RESET}"
print "#{exit_fg_color}#{LT}#{RESET}"
print "#{exit_bg_color}#{exit_code_str}#{RESET}"
print "#{BG_YELLOW_FG_BLACK}#{time_str}#{RESET}"
print "#{FG_YELLOW}#{GT}#{RESET}"
puts "#{GRAY}#{dots}#{RESET}"
puts "#{GRAY}进程已结束。按任意键退出...#{RESET}" # "close window" is controlled by Terminal.app preference
STDIN.getch
