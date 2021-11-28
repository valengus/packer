Install-PackageProvider -name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module PSWindowsUpdate -Confir:$False -Force
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
Import-Module PSWindowsUpdate

Invoke-WUJob -Script {Import-Module PSWindowsUpdate ; Install-WindowsUpdate -NotCategory Drivers -NotTitle Silverlight -MicrosoftUpdate -AcceptAll -IgnoreReboot } -RunNow:$False -Confirm:$False -TaskName 'WindowsUpdate' -Force

Start-Sleep -Seconds  10
SCHTASKS.EXE /RUN /I /TN 'WindowsUpdate'

while ( (Get-ScheduledTask -TaskName 'WindowsUpdate').State -ne  'Ready') { Start-Sleep -Seconds  180 }

Unregister-ScheduledTask -TaskName 'WindowsUpdate' -Confirm:$false