import * as os from "node:os";
import * as vscode from "vscode";

// https://guyutongxue.github.io/blogs/args.html

function argvToShell(argv: string[]) {
  return argv
    .map((arg) => `"${arg.replace(/(\$|`|"|\\)/g, "\\$1")}"`)
    .join(" ");
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
  name: string,
  argv: string[],
  options: vscode.ProcessExecutionOptions = {}
) {
  // NEVER USE CMD.EXE !
  if (name.endsWith(".ps1")) {
    return new vscode.ProcessExecution(
      "C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe",
      ["-ExecutionPolicy", "ByPass", "-NoProfile", "-File", name, ...argv]
    );
  } else {
    console.log({ name, argv, options });
    return new vscode.ProcessExecution(name, argv, options);
  }
}
