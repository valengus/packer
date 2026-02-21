Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

Install-PackageProvider -name NuGet -Force
Install-Module PSWindowsUpdate -Confir:$False -Force
Import-Module PSWindowsUpdate

Install-WindowsUpdate -NotCategory Drivers -NotTitle Silverlight -MicrosoftUpdate -AcceptAll -IgnoreReboot
