param (
   [string]$SALT_MASTER_SERVER = "salt",
   [string]$SALT_AGENT_ENVIRONMENT = "base"
)

$WORKSTATION_FQDN = (Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain
$SALT_MINION_ID = $WORKSTATION_FQDN.ToLower()

$SALT_MINION_version = '3007.1'
$SALT_MINION_x64_download_path = "https://repo.saltproject.io/salt/py3/windows/minor/$SALT_MINION_version/Salt-Minion-$SALT_MINION_version-Py3-AMD64-Setup.exe"
$SALT_MINION_x86_download_path = "https://repo.saltproject.io/salt/py3/windows/minor/$SALT_MINION_version/Salt-Minion-$SALT_MINION_version-Py3-x86-Setup.exe"

if ($env:PROCESSOR_ARCHITECTURE -eq "amd64") {
    
  Write-Host "64-bit Operating System"
  $WebClient = New-Object System.Net.WebClient
  $WebClient.DownloadFile("$SALT_MINION_x64_download_path","$env:TEMP\Salt-Minion.exe")
  Start-Process "$env:TEMP\Salt-Minion.exe" -Wait -ArgumentList "/S /master=$SALT_MASTER_SERVER /start-minion-delayed /start-minion=0"
  Remove-Item -Path "$env:TEMP\Salt-Minion.exe"

} Else {

  Write-Host "Operating System Is Not 64-bit"

}

Get-Service salt-minion | Set-Service -StartupType Disabled