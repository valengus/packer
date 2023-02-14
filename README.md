
```bash
export TMPDIR=/var/tmp/ 
```

```bash
packer build --only=windows.virtualbox-iso.windows10-22h2-x64 ./windows.pkr.hcl
packer build --only=windows.virtualbox-iso.windows-2022-standard ./windows.pkr.hcl
packer build --only=windows.virtualbox-iso.windows-2022-standard-core ./windows.pkr.hcl

packer build --only=windows.qemu.windows10-22h2-x64 ./windows.pkr.hcl
packer build --only=windows.qemu.windows-2022-standard ./windows.pkr.hcl
packer build --only=windows.qemu.windows-2022-standard-core ./windows.pkr.hcl
```