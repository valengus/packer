
# checking if sysprep running
$sysprep = Get-Process sysprep -ErrorAction SilentlyContinue
if ($sysprep -eq $null) { exit 0 } else { exit 1 }

