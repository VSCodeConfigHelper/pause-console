﻿$Host.UI.RawUI.BackgroundColor = 'Black'
Clear-Host
if ($args.Length -eq 0) {
    Write-Host "Usage: $PSCommandPath <Executable> [<Arguments...>]"
    exit
}
$Host.UI.RawUI.WindowTitle = $args[0]
$startTime = $(Get-Date)
$proc = Start-Process -FilePath $args[0] -ArgumentList $args[1..($args.Count-1)] -NoNewWindow -PassThru
$handle = $proc.Handle # https://stackoverflow.com/a/23797762/1479211
$proc.WaitForExit()
[TimeSpan]$elapsedTime = $(Get-Date) - $startTime

Write-Host
Write-Host "----------------" -NoNewline
$exitCode = $proc.ExitCode
if ($exitCode -eq 0) {
    $exitColor = 'Green'
} else {
    $exitColor = 'Red'
}
# PowerLine Glyphs < and >
$gt = [char]0xe0b0
$lt = [char]0xe0b2
Write-Host "$lt" -ForegroundColor $exitColor -NoNewline
Write-Host (" 返回值 {0} " -f $exitCode) -BackgroundColor $exitColor -NoNewline
Write-Host (" 用时 {1:n4}s " -f $exitCode, $elapsedTime.TotalSeconds) -BackgroundColor 'Yellow' -ForegroundColor 'Black' -NoNewline
Write-Host "$gt" -ForegroundColor 'Yellow' -NoNewline
Write-Host "----------------"
Write-Host "进程已退出。按任意键关闭窗口..." -NoNewline
[void][System.Console]::ReadKey($true)
