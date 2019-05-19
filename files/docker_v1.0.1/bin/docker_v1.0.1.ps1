$ErrorActionPreference = "Stop"
$DOCKER_SERVICE_NAME = "Docker"
Write-Output "Find Package Provider"
Add-Content docker-install.out "Start Find Package Provider"
Find-PackageProvider -Name "Nuget" | Install-PackageProvider -Force
Add-Content docker-install.out "Find Package Provider - Completed"
Add-Content docker-install.out "Start Install-Module DockerMsftProvider"
Install-Module -Name "DockerMsftProvider" -Repository "PSGallery" -Force
Add-Content docker-install.out "Install-Module DockerMsftProvider - Completed"
Add-Content docker-install.out "Install-Package Docker - Starting"
Install-Package -Name "Docker" -ProviderName "DockerMsftProvider" -Force 
Add-Content docker-install.out "Install-Package Docker - Completed"
Start-Sleep -s 30
Add-Content docker-install.out "Set-Service"
Set-Service $DOCKER_SERVICE_NAME -StartupType Disabled
Add-Content docker-install.out "Stop-Service"
Stop-Service $DOCKER_SERVICE_NAME
Get-HnsNetwork | Where-Object { $_.Name -eq "nat" } | Remove-HnsNetwork
$configFile = Join-Path $env:ProgramData "Docker\config\daemon.json"
$configDir = Split-Path -Path $configFile -Parent
if(!(Test-Path $configDir)) {
    New-Item -ItemType "Directory" -Force -Path $configDir
    }
Set-Content -Path $configFile -Value '{ "bridge" : "none" }' -Encoding Ascii
Add-Content c:\scripts\test.txt "Set-Service Auto Mode"
Set-Service $DOCKER_SERVICE_NAME -StartupType Automatic
sc.exe failure $DOCKER_SERVICE_NAME reset=40 actions=restart/0/restart/0/restart/30000
if($LASTEXITCODE) {
    Throw "Failed to set failure actions"
    }
sc.exe failureflag $DOCKER_SERVICE_NAME 1
if($LASTEXITCODE) {
      Throw "Failed to set failure flags"
      }
Add-Content c:\scripts\test.txt "Final Start Service"
Start-Service $DOCKER_SERVICE_NAME
Write-Output "Install Finished"

