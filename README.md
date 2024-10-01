


packer init ./windows.pkr.hcl
packer build -force --only=windows.hyperv-iso.windows11 ./windows.pkr.hcl
