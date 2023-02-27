# Console Pauser - 控制台暂停脚本

## 介绍

Visual Studio 的 Windows 本地调试器在运行完控制台 C++ 程序后，可以“暂停”控制台的退出，以观察程序输出。Dev-C++ 和 Code::Blocks 也实现了类似的功能，基本原理是运行一个称为 `ConsolePauser` 或 `ConsoleRunner` 的程序；该程序以子进程方式启动目标程序，并在目标程序退出后暂停，等待用户输入后退出。

本项目的目标，是在 Visual Studio Code 中实现类似的功能。VSCodeConfigHelper v2/v3 使用本项目的脚本代码以实现外部弹窗运行功能；于 v4 直接以 VS Code 扩展形式引入。

## Usage

In `tasks.json`:

```jsonc
{
  "type": "pause-console",
  "command": "<EXECUTABLE>",
  "args": [ "<ARGS>" ],
  "options": {
    "env": {},
    "cwd": "<CWD>"
  },
  "problemMatcher": []
}
```
