import * as os from "node:os";
import * as fs from "node:fs";
import * as path from "node:path";
import * as bplist from "bplist-parser";
import * as vscode from "vscode";
import * as glob from "glob";
import { TerminalEmulator } from "./terminal_emulators";

// https://guyutongxue.github.io/blogs/args.html

function argvToShell(argv: string[]) {
  return argv.map((arg) => `"${arg.replace(/([$`"\\])/g, "\\$1")}"`).join(" ");
}

function argvToCommandLine(argv: string[]) {
  return argv
    .map((arg) => {
      let rev = '"'; // 逆向构造
      let quoteHit = true; // 是否处于保留引号的区间
      for (let i = arg.length - 1; i >= 0; i--) {
        rev += arg[i];
        if (quoteHit && arg[i] === "\\") {
          // 若需要保留引号，则添加额外的反斜杠
          rev += "\\";
        } else if (arg[i] === '"') {
          quoteHit = true;
          rev += "\\";
        } else {
          quoteHit = false;
        }
      }
      rev += '"';
      // 反转为正向字符串
      return Array.from(rev).reverse().join("");
    })
    .join(" ");
}

function argvToCmdDotExe(argv: string[]) {
  if (argv.join("").includes("\n")) {
    throw new Error(`不允许在命令行中包含换行符`);
  }
  return argvToCommandLine(argv).replace(/(.)/g, "^$1");
}

export function createExecution(
  emu: TerminalEmulator,
  args: string[],
  options: vscode.ProcessExecutionOptions = {}
) {
  const script = path.resolve(__dirname, "../scripts/", emu.script);
  if (emu.name === "cmd") {
    // launch PowerShell script
    return new vscode.ProcessExecution(
      "C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe",
      ["-ExecutionPolicy", "ByPass", "-NoProfile", "-File", script, ...args],
      options
    );
  }
  if (emu.name === "iterm2") {
    // Find correct Python environment
    const myGlob = `${process.env.HOME}/Library/Application Support/iTerm2/iterm2env/versions/*/bin/python3`;
    const results = glob.sync(myGlob);
    if (results.length === 0) {
      throw new Error("No iTerm2 Python environment found!");
    }
    const py3 = results[0];
    return new vscode.ProcessExecution(py3, [script, ...args], options);
  }
  if (emu.name === "terminal") {
    // Conditionally wait and close the window
    try {
      const filepath = `${process.env.HOME}/Library/Preferences/com.apple.Terminal.plist`;
      const buf = fs.readFileSync(filepath);
      const obj = bplist.parseBuffer(buf)[0];
      console.log(obj);
      const profName = obj["Default Window Settings"] as string;
      const prof = obj["Window Settings"][profName];
      const ea = prof["shellExitAction"];
      if (ea === 2) {
        options.env = {
          ...(options.env ?? {}),
          PAUSE_CONSOLE_WAIT_AND_CLOSE: "1",
        };
      }
    } catch (e) {
      console.error(`Failed to resolve Terminal.app preference: ${e}`);
    }
  }
  console.log({ script, argv: args, options });
  return new vscode.ProcessExecution(script, args, options);
}
