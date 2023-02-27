$Host.UI.RawUI.BackgroundColor = 'Black'
Clear-Host
if ($args.Length -eq 0) {
  Write-Host "Usage: $PSCommandPath <Executable> [<Arguments...>]"
  exit
}
$Host.UI.RawUI.WindowTitle = $args[0]

$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ("$ScriptDirectory\convertto-commandline.ps1")
$quotedArgs = ConvertTo-CommandLine $args[1..($args.Count - 1)]

if ($args.Count -ne 1) {
  $quotedArgs = ConvertTo-CommandLine $args[1..($args.Count - 1)]
  $startTime = $(Get-Date)
  $proc = Start-Process -FilePath $args[0] -ArgumentList $quotedArgs -NoNewWindow -PassThru
} else {
  $startTime = $(Get-Date)
  $proc = Start-Process -FilePath $args[0] -NoNewWindow -PassThru
}
$handle = $proc.Handle # https://stackoverflow.com/a/23797762/1479211
$proc.WaitForExit()
[TimeSpan]$elapsedTime = $(Get-Date) - $startTime

$exitCodeStr = " 退出码 {0} " -f $exitCode
$timeStr = " 用时 {0:n4}s " -f $elapsedTime.TotalSeconds
$termWidth = $Host.UI.RawUI.WindowSize.Width
$hintWidth = $exitCodeStr.Length + $timeStr.Length + 7 # 5 CJK character and 2 Powerline Glyphs
$dots = [String]::new([char]0x2d, [Math]::Floor(($termWidth - $hintWidth) / 2))
$exitCode = $proc.ExitCode
if ($exitCode -eq 0) {
    $exitColor = 'Green'
} else {
    $exitColor = 'Red'
}
# PowerLine Glyphs < and >
$gt = [char]0xe0b0
$lt = [char]0xe0b2

Write-Host
Write-Host "$dots" -ForegroundColor 'DarkGray' -NoNewline
Write-Host "$lt" -ForegroundColor $exitColor -NoNewline
Write-Host (" 退出码 {0} " -f $exitCode) -BackgroundColor $exitColor -NoNewline
Write-Host (" 用时 {0:n4}s " -f $elapsedTime.TotalSeconds) -BackgroundColor 'Yellow' -ForegroundColor 'Black' -NoNewline
Write-Host "$gt" -ForegroundColor 'Yellow' -NoNewline
Write-Host "$dots" -ForegroundColor 'DarkGray'
Write-Host "进程已结束。按任意键关闭窗口..."  -ForegroundColor 'DarkGray' -NoNewline
[void][System.Console]::ReadKey($true)
