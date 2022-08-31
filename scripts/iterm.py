#!/usr/bin/env python3

from typing import List
import iterm2
import AppKit
import shlex
import sys
import os

AppKit.NSWorkspace.sharedWorkspace().launchApplication_("iTerm2")

def join_args(args: List[str]) -> str:
  line = ""
  for i in args:
    line += '"'
    for c in i:
      if c in ['$', '`', '\\', '"']:
        line += '\\'
      line += c
    line += '" '
  return line

async def main(connection):
  script_dir = os.path.dirname(os.path.abspath(__file__))
  args = ' '.join(map(shlex.quote, sys.argv[1:])) # shlex.join not available in py3.7-
  # args = join_args(sys.argv[1:])
  cmd = f"{script_dir}/pause-console.rb {args}"
  with open("/Users/guyutongxue/a.txt", "w") as f:
    f.write(format(sys.argv))
    f.write(cmd)
  app = await iterm2.async_get_app(connection)
  await app.async_activate()
  await iterm2.Window.async_create(connection, command=cmd)

iterm2.run_until_complete(main)
