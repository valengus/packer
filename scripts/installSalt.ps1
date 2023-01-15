$WebClient = New-Object System.Net.WebClient
$salt_minion_download_path = "https://repo.saltproject.io/windows/Salt-Minion-3005.1-Py3-AMD64.msi"
$WebClient.DownloadFile("$salt_minion_download_path","$env:TEMP\Salt-Minion.msi")
Start-Process msiexec.exe -Wait -ArgumentList "/qn /norestart /i $env:TEMP\Salt-Minion.msi START_MINION=0"
Remove-Item -Path "$env:TEMP\Salt-Minion.msi"


Stop-Service -Name 'salt-minion'
