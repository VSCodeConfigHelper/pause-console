$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ("$ScriptDirectory\convertto-commandline.ps1")
$quotedArgs = ConvertTo-CommandLine(@("-ExecutionPolicy", "ByPass", "-NoProfile", "-File", "$ScriptDirectory\pause-console.ps1") + $args)

Start-Process -FilePath "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" -ArgumentList $quotedArgs
