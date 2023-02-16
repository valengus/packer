```bash
export TMPDIR=/var/tmp/
export CLOUD_TOKEN="..."

export PKR_VAR_cpus=4
export PKR_VAR_memory=8192
export PKR_VAR_headless=false

```

```bash
packer build --only=windows.virtualbox-iso.windows10-22h2-x64 ./windows.pkr.hcl
packer build --only=windows.virtualbox-iso.windows-2022-standard ./windows.pkr.hcl
packer build --only=windows.virtualbox-iso.windows-2022-standard-core ./windows.pkr.hcl

packer build --only=windows.qemu.windows10-22h2-x64 ./windows.pkr.hcl
packer build --only=windows.qemu.windows-2022-standard ./windows.pkr.hcl
packer build --only=windows.qemu.windows-2022-standard-core ./windows.pkr.hcl

packer build -force --only=windows.vmware-iso.windows10-22h2-x64 ./windows.pkr.hcl
packer build -force --only=windows.vmware-iso.windows-2022-standard ./windows.pkr.hcl
packer build -force --only=windows.vmware-iso.windows-2022-standard-core ./windows.pkr.hcl
```