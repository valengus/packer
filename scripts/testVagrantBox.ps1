# checking if sysprep running
$sysprep = Get-Process sysprep -ErrorAction SilentlyContinue
if ($sysprep -ne $null) { exit 1 }

# checking chocolatey
choco install vscode -y
