# https://guyutongxue.github.io/blogs/args.html
function ConvertTo-CommandLine([string[]]$argv) {
  $cmd = ""
  $BS = [char]0x5c #Backslash
  $QT = [char]0x22 #Double quote
  foreach ($arg in $argv) {
    $cmd += "`""
  for ($i = 0; $i -lt $arg.Length; $i++) {
      $slashNum = 0
      while (($i -ne $arg.Length) -and ($arg[$i] -eq $BS)) {
        $i++
        $slashNum++
      }
      if ($i -eq $arg.Length) {
        $cmd += [String]::new($BS, $slashNum * 2)
      } elseif ($arg[$i] -eq $QT) {
        $cmd += [String]::new($BS, $slashNum * 2 + 1)
        $cmd += "`""
      } else {
        $cmd += [String]::new($BS, $slashNum)
        $cmd += $arg[$i]
      }
    }
    $cmd += "`" "
  }
  return $cmd
}
