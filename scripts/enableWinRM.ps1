Get-NetConnectionProfile `
    | Where-Object {$_.NetworkCategory -ne 'DomainAuthenticated'} `
    | Set-NetConnectionProfile -NetworkCategory Private

Write-Output 'Configuring WinRM...'
winrm quickconfig -quiet
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

netsh advfirewall firewall set rule group="remote administration" new enable=yes
