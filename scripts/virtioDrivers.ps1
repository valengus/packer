$cert = (Get-AuthenticodeSignature "E:\qxldod\qxldod.cat").SignerCertificate
[System.IO.File]::WriteAllBytes("$env:TEMP\redhat_qxldod.cer", $cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
certutil.exe -f -addstore "TrustedPublisher" $env:TEMP\redhat_qxldod.cer

$cert = (Get-AuthenticodeSignature "E:\Balloon\blnsvr.exe").SignerCertificate
[System.IO.File]::WriteAllBytes("$env:TEMP\redhat_balloon.cer", $cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
certutil.exe -f -addstore "TrustedPublisher" $env:TEMP\redhat_balloon.cer

$drivers = 'Balloon', 'NetKVM', 'pvpanic', 'qxldod', 'vioinput', 'viorng', 'vioscsi', 'vioserial'
foreach ($driver in $drivers) {
  pnputil.exe /add-driver E:\$driver\*.inf /install
}

$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.248-1/virtio-win-gt-x64.msi","$env:TEMP\virtio-win-gt-x64.msi")
# Start-Process msiexec.exe -Wait -ArgumentList "/I $env:TEMP\virtio-win-gt-x64.msi /qn /norestart"
msiexec.exe /I $env:TEMP\virtio-win-gt-x64.msi /qn /norestart
Remove-Item -Path "$env:TEMP\virtio-win-gt-x64.msi" -Force

# Install SPICE Guest Tools
Write-Output "Downloading SPICE Guest Tools"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://www.spice-space.org/download/windows/vdagent/vdagent-win-0.10.0/vdagent-win-0.10.0-x64.zip","$env:TEMP\vdagent-win-0.10.0-x64.zip")
Expand-Archive -Path $env:TEMP\vdagent-win-0.10.0-x64.zip -DestinationPath "${Env:ProgramFiles(x86)}"
Rename-Item -Path "${Env:ProgramFiles(x86)}\vdagent-win-0.10.0-x64" -NewName "${Env:ProgramFiles(x86)}\SPICE Guest Tools"
Write-Output "Installing SPICE Guest Tools"
& "${Env:ProgramFiles(x86)}\SPICE Guest Tools\vdservice.exe" install
Write-Output "Cleanup"
Remove-Item -Path "$env:TEMP\vdagent-win-0.10.0-x64.zip" -Force
