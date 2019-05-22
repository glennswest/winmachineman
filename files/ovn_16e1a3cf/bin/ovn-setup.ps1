$ErrorActionPreference = "Stop"
$env:item = ${env:ProgramFiles}\Cloudbase Solutions\Open vSwitch\bin\
$systemPath = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") -split ';'
if($env:item -notin $systemPath) {
  $systemPath += $env:item
  [System.Environment]::SetEnvironmentVariable("PATH", ($systemPath -join ';'), "Machine")
  }
$env:item = C:\bin
$systemPath = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") -split ';'
if($env:item -notin $systemPath) {
  $systemPath += $env:item
  [System.Environment]::SetEnvironmentVariable("PATH", ($systemPath -join ';'), "Machine")
  }
Set-Service -Name ovsdb-server -StartupType Automatic
Start-Service ovsdb-server
