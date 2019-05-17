$ErrorActionPreference = "Stop"
$DOCKER_SERVICE_NAME = "Docker"
Write-Output "Installing Docker {{ windows_docker_version }}"
Find-PackageProvider -Name "Nuget" | Install-PackageProvider -Force
Install-Module -Name "DockerMsftProvider" -Repository "PSGallery" -Force
Install-Package -Name "Docker" -ProviderName "DockerMsftProvider" -Force 
Set-Service $DOCKER_SERVICE_NAME -StartupType Disabled
Stop-Service $DOCKER_SERVICE_NAME
Get-HnsNetwork | Where-Object { $_.Name -eq "nat" } | Remove-HnsNetwork
$configFile = Join-Path $env:ProgramData "Docker\config\daemon.json"
$configDir = Split-Path -Path $configFile -Parent
if(!(Test-Path $configDir)) {
    New-Item -ItemType "Directory" -Force -Path $configDir
    }
Set-Content -Path $configFile -Value '{ "bridge" : "none" }' -Encoding Ascii
Set-Service $DOCKER_SERVICE_NAME -StartupType Automatic
sc.exe failure $DOCKER_SERVICE_NAME reset=40 actions=restart/0/restart/0/restart/30000
if($LASTEXITCODE) {
    Throw "Failed to set failure actions"
    }
sc.exe failureflag $DOCKER_SERVICE_NAME 1
if($LASTEXITCODE) {
      Throw "Failed to set failure flags"
      }
Start-Service $DOCKER_SERVICE_NAME
