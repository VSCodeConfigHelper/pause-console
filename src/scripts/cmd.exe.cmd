@ECHO OFF
START C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe -ExecutionPolicy ByPass -NoProfile -File %~dp0\\pause-console.ps1 %*
