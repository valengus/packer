# Download iso to iso/Win11_25H2_English_x64.iso
https://www.microsoft.com/en-in/software-download/windows11

# Init
packer init windows-11-25h2-audit-mode.pkr.hcl

# Build
export TMPDIR=/var/tmp/
packer build -force windows-11-25h2-audit-mode.pkr.hcl

# Test
vagrant box add --force --name windows-11-25h2-audit-mode virtualbox-iso-windows-11-25h2-audit-mode.box
vagrant up

# Cleanup
rm -f ./virtualbox-iso-windows-11-25h2-audit-mode.box
vagrant destroy -f
vagrant box remove windows-11-25h2-audit-mode
