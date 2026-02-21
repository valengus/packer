Dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase

Stop-Service wuauserv
Remove-Item -Path C:\Windows\SoftwareDistribution\Download\* -Recurse -Force
