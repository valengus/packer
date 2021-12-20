# install
Add-WindowsCapability -Online -Name (Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*').Name

# set powershell as default shell
# New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

# enable sshd
# Set-Service -Name sshd -StartupType Automatic