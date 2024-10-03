$cert = (Get-AuthenticodeSignature "E:\qxldod\qxldod.cat").SignerCertificate
[System.IO.File]::WriteAllBytes("$env:TEMP\redhat_qxldod.cer", $cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
certutil.exe -f -addstore "TrustedPublisher" $env:TEMP\redhat_qxldod.cer

$cert = (Get-AuthenticodeSignature "E:\Balloon\blnsvr.exe").SignerCertificate
[System.IO.File]::WriteAllBytes("$env:TEMP\redhat_balloon.cer", $cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
certutil.exe -f -addstore "TrustedPublisher" $env:TEMP\redhat_balloon.cer

$drivers = 'Balloon', 'NetKVM', 'pvpanic', 'qxldod', 'vioinput', 'viorng', 'vioscsi', 'vioserial', 'viostor'
foreach ($driver in $drivers) {
  pnputil.exe /add-driver E:\$driver\*.inf /install
}
