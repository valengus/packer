# Use graphical install
graphical
firstboot --disable

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=em1 --onboot=yes --hostname=fedora38

# Firewall configuration
firewall --enabled --service=ssh

# Repo
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64"
repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64" --cost=0

%packages
@^workstation-product-environment
open-vm-tools
python3
python3-pip 
git
salt-minion
%end

# Partition clearing information
clearpart --none --initlabel

# Disk partitioning information
autopart --type=plain --noboot --nohome --noswap --nolvm --fstype=xfs

# System timezone
timezone Europe/Kiev --utc

services --enabled=NetworkManager,sshd

reboot --eject

#Root password
rootpw --lock
user --groups=wheel --name=vagrant --password=$y$j9T$L83PogYRldDZUF44r9JOSvq/$/8SzfH2HQoh6GznvkQHaY/9sGDojNp6voWYvRj9mTWC --iscrypted --gecos="vagrant"

%post

cat > /etc/sudoers.d/wheel <<EOF
%wheel  ALL=(ALL)       NOPASSWD: ALL
EOF

%end