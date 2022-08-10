#!/Applications/iTerm.app/Contents/Resources/it2run

import iterm2
import AppKit
import shlex
import sys
import os

AppKit.NSWorkspace.sharedWorkspace().launchApplication_("iTerm2")


async def main(connection):
  script_dir = os.path.dirname(__file__)
  cmd = f"{script_dir}/pause-console.rb {' '.join(map(shlex.quote, sys.argv[1:]))}; exit"
  app = await iterm2.async_get_app(connection)
  await app.async_activate()
  profile = iterm2.LocalWriteOnlyProfile()
  profile.set_close_sessions_on_end(True)
  await iterm2.Window.async_create(connection, command=cmd, profile_customizations=profile)

iterm2.run_until_compelete(main)
