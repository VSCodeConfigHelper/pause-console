import * as vscode from "vscode";
import * as path from "node:path";
import * as os from "node:os";
import { LINUX, MACOS, TerminalEmulator, WINDOWS } from "./terminal_emulators";
import { execSync } from "node:child_process";
import { createExecution } from "./execution";

interface PauseConsoleTaskDefinition extends vscode.TaskDefinition {
  command: string;
  args?: string[];
  options?: {
    cwd?: string;
    env?: Record<string, string>;
  };
}

function testEmulator(e: TerminalEmulator) {
  if (typeof e.test === "undefined") return true;
  try {
    execSync(e.test);
    return true;
  } catch {
    return false;
  }
}

function getPauser(): TerminalEmulator {
  let platform: string;
  let emulators: TerminalEmulator[];
  switch (os.platform()) {
    case "win32":
      platform = "windows";
      emulators = WINDOWS;
      break;
    case "darwin":
      platform = "macos";
      emulators = MACOS;
      break;
    case "linux":
      platform = "linux";
      emulators = LINUX;
      break;
    default:
      throw new Error("Unsupported platform: " + os.platform());
  }
  const config = vscode.workspace
    .getConfiguration("pause-console")
    .get<string>(`terminalEmulator.${platform}`)!;

  let emu: TerminalEmulator | undefined;
  if (config === "auto") {
    for (const e of emulators) {
      if (testEmulator(e)) {
        emu = e;
        break;
      }
    }
    if (typeof emu === "undefined") {
      throw new Error(`No available terminal emulator found.`);
    }
  } else {
    emu = emulators.find((e) => e.name === config);
    if (typeof emu === "undefined") {
      throw new Error(`Unknown terminal emulator: ${config}`);
    }
  }

  return emu;
}

export function activate(context: vscode.ExtensionContext) {
  const taskProvider = vscode.tasks.registerTaskProvider("pause-console", {
    provideTasks: () => [],
    resolveTask: (task) => {
      const def = task.definition as PauseConsoleTaskDefinition;
      const args = [def.command, ...(def.args ?? [])];
      return new vscode.Task(
        def,
        vscode.TaskScope.Workspace,
        task.name,
        task.source,
        createExecution(getPauser(), args, def.options)
      );
    },
  });
  context.subscriptions.push(taskProvider);
}

export function deactivate() {}
