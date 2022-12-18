
```bash
TMPDIR=/var/tmp/ packer build --force --only=windows.virtualbox-iso.windows10-22h2-x64-pro  ./windows.pkr.hcl
TMPDIR=/var/tmp/ packer build --force --only=windows.virtualbox-iso.windows-2022-standard  ./windows.pkr.hcl
TMPDIR=/var/tmp/ packer build --force --only=windows.virtualbox-iso.windows-2022-standard-core  ./windows.pkr.hcl

TMPDIR=/var/tmp/ packer build --force --only=windows.qemu.windows10-22h2-x64-pro  ./windows.pkr.hcl
TMPDIR=/var/tmp/ packer build --force --only=windows.qemu.windows-2022-standard  ./windows.pkr.hcl
TMPDIR=/var/tmp/ packer build --force --only=windows.qemu-iso.windows-2022-standard-core  ./windows.pkr.hcl
```