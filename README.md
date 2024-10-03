### WINDOWS VAGRANT BOXES

- image prepared in "Audit Mode"
- image was finalized using sysprep
- system drive will be extended during first startup, you can use vagrant-disksize plugin
- hibernate mode disabled
- updates ( 01.10.2024 )
- drivers for kvm (viostor, netkvm, viorng, vioserial, qxldod, balloon)
- qemu|virtualbox|vmware guest agent
- winrm will be enabled over https during startup
- remote desktop allowed
- additional software ['salt-minion']

### Login Credentials
Username: Administrator \ vagrant

Password: vagrant


```bash
export HCL_CLIENT_ID="..." ; 
export HCL_CLIENT_secret="..."
export TMPDIR=/var/tmp/
export PKR_VAR_headless=false

packer init ./windows.pkr.hcl
packer plugins install github.com/hashicorp/qemu

packer build -force --only=windows.virtualbox-iso.windows11 ./windows.pkr.hcl
packer build -force --only=windows.virtualbox-iso.windows-2022-standard ./windows.pkr.hcl
packer build -force --only=windows.virtualbox-iso.windows-2022-standard-core ./windows.pkr.hcl
```

```powershell

$Env:HCL_CLIENT_ID = "..."
$Env:HCL_CLIENT_secret = "..."
$Env:PKR_VAR_headless = false

packer init ./windows.pkr.hcl
packer build -force --only=windows.hyperv-iso.windows11 ./windows.pkr.hcl
packer build -force --only=windows.hyperv-iso.windows-2022-standard ./windows.pkr.hcl
packer build -force --only=windows.hyperv-iso.windows-2022-standard-core ./windows.pkr.hcl
```
