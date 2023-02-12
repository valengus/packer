Install-PackageProvider -name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module PSWindowsUpdate -Confir:$False -Force
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
Import-Module PSWindowsUpdate

Install-WindowsUpdate -NotCategory Drivers -NotTitle Silverlight -MicrosoftUpdate -AcceptAll -IgnoreReboot