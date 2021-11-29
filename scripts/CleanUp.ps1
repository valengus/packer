# Cleanup updates
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
Dism.exe /online /Cleanup-Image /SPSuperseded

# Remove available WindowsFeature
# Get-WindowsFeature | ? { $_.InstallState -eq 'Available' } | Uninstall-WindowsFeature -Remove

# Defrag С
Optimize-Volume -DriveLetter C -Defrag

# SDelete
sdelete -z c: