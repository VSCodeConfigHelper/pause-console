# Console Pauser - 控制台暂停脚本

## 介绍

Visual Studio 的 Windows 本地调试器在运行完控制台 C++ 程序后，可以“暂停”控制台的退出，以观察程序输出。Dev-C++ 和 Code::Blocks 也实现了类似的功能，基本原理是运行一个称为 `ConsolePauser` 或 `ConsoleRunner` 的程序；该程序以子进程方式启动目标程序，并在目标程序退出后暂停，等待用户输入后退出。

本项目的目标，是在 Visual Studio Code 中实现类似的功能。VSCodeConfigHelper v2 及之后版本使用本项目的代码以实现外部弹窗运行功能。

## 使用方法

在 `tasks.json` 中引入如下定义。其中 `<SCRIPT_PATH>` 指脚本路径，`<TARGET_EXECUTABLE>` 指目标程序。

```json
{
  "type": "shell",
  "label": "run and pause",
  "presentation": {
    "reveal": "never",
    "focus": false,
    "echo": false,
    "showReuseMessage": false,
    "panel": "shared",
    "clear": true
  },
  // Platform specific, SEE BELOW
  "problemMatcher": []
}
```

### Windows

Windows 使用 `pause-console.ps1` 脚本。

```json
{
  "command": "START",
  "args": [
    "C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe",
    "-ExecutionPolicy",
    "ByPass",
    "-NoProfile",
    "-File",
    "<SCRIPT_PATH>",
    "<TARGET_EXECUTABLE>"
  ],
  "options": {
    "shell": {
      "executable": "C:\\Windows\\system32\\cmd.exe",
      "args": ["/C"]
    }
  }
}
```

### Linux（需支持 `x-terminal-emulator`）

Linux 使用 `pause-console.sh` 脚本。

```json
{
  "command": "x-terminal-emulator",
  "args": [
    "-e",
    "<SCRIPT_PATH>",
    "<TARGET_EXECUTABLE>"
  ]
}
```

### macOS

macOS 自带进程退出后的窗口保持设计。如使用本项目，建议将设置中的 Shell Exit Action 设为直接退出（`0`）。

macOS 使用 `pause-console.rb` 脚本，但额外使用 `pause-console-launcher.sh` 启动器脚本；其路径记作 `<LAUNCHER_PATH>`。两脚本应位于同一路径下。

```json
{
  "command": "<LAUNCHER_PATH>",
  "args": ["<TARGET_EXECUTABLE>"]
}
```
