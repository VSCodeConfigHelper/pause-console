import * as path from "node:path";

export type TerminalEmulator = {
  name: string;
  script: string;
  test?: string;
};

export const LINUX: TerminalEmulator[] = [
  {
    name: "x",
    script: "x-terminal-emulator.sh",
    test: "command -v x-terminal-emulator"
  },
  {
    name: "cmd",
    script: path.join(__dirname, "../node_modules/@gytx/pause-console-wsl/bin/entry.sh"),
    test: "command -v cmd.exe"
  },
  {
    name: "terminator",
    script: "terminator.sh",
    test: "command -v xterminator"
  },
  {
    name: "konsole",
    script: "konsole.sh",
    test: "command -v konsole"
  },
  {
    name: "gnome",
    script: "gnome-terminal.sh",
    test: "command -v gnome-terminal"
  },
  {
    name: "guake",
    script: "guake.sh",
    test: "command -v guake"
  },
  {
    name: "urxvt",
    script: "urxvt.sh",
    test: "command -v urxvt"
  },
  {
    name: "xfce4",
    script: "xfce4-terminal.sh",
    test: "command -v xfce4-terminal"
  },
  {
    name: "kitty",
    script: "kitty.sh",
    test: "command -v kitty"
  },
  {
    name: "alarcitty",
    script: "alarcitty.sh",
    test: "command -v alarcitty"
  },
  {
    name: "xterm",
    script: "xterm.sh",
    test: "command -v xterm"
  }
];

export const WINDOWS: TerminalEmulator[] = [
  {
    name: "cmd",
    script: "cmd.exe.ps1",
  },
];

export const MACOS: TerminalEmulator[] = [
  {
    name: "terminal",
    script: "terminal.app.sh",
  },
];
