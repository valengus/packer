### WINDOWS VAGRANT BOXES

- image prepared in "Audit Mode"
- image was finalized using sysprep
- system drive will be extended during first startup, you can use vagrant-disksize plugin
- hibernate mode disabled
- drivers for kvm (viostor, netkvm, viorng, vioserial, qxldod, balloon)
- qemu|virtualbox|vmware guest agent
- winrm will be enabled over https during first startup
- remote desktop will be enabled over https during first startup
- additional software ['salt-minion', 'chocolatey', 'sdelete']

### Login Credentials
Username: Administrator

Password: password


```bash
export HCL_CLIENT_ID="..." ; 
export HCL_CLIENT_secret="..."
export TMPDIR=/var/tmp/
export PKR_VAR_headless=false

packer init ./windows.pkr.hcl
packer plugins install github.com/hashicorp/qemu

vagrant plugin install winrm
vagrant plugin install winrm-fs
vagrant plugin install winrm-elevated

packer build -force --only=windows.qemu.windows-11-22h2 ./windows.pkr.hcl
packer build -force --only=windows.qemu.windows-2022-standard ./windows.pkr.hcl
packer build -force --only=windows.qemu.windows-2022-standard-core ./windows.pkr.hcl

packer build -force --only=windows.virtualbox-iso.windows-11-22h2 ./windows.pkr.hcl
packer build -force --only=windows.virtualbox-iso.windows-2022-standard ./windows.pkr.hcl
packer build -force --only=windows.virtualbox-iso.windows-2022-standard-core ./windows.pkr.hcl
```

```powershell
$Env:HCL_CLIENT_ID = "..."
$Env:HCL_CLIENT_secret = "..."
$Env:PKR_VAR_headless = "false"

packer init ./windows.pkr.hcl

vagrant plugin install winrm
vagrant plugin install winrm-fs
vagrant plugin install winrm-elevated
vagrant plugin install vagrant-vmware-desktop

packer build -force --only=windows.hyperv-iso.windows-11-22h2 ./windows.pkr.hcl
packer build -force --only=windows.hyperv-iso.windows-2022-standard ./windows.pkr.hcl
packer build -force --only=windows.hyperv-iso.windows-2022-standard-core ./windows.pkr.hcl

packer build -force --only=windows.vmware-iso.windows-11-22h2 ./windows.pkr.hcl
packer build -force --only=windows.vmware-iso.windows-2022-standard ./windows.pkr.hcl
packer build -force --only=windows.vmware-iso.windows-2022-standard-core ./windows.pkr.hcl
```
