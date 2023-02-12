### WINDOWS SERVER 2022 STANDARD CORE :

[source](https://github.com/valengus/packer.git)

- image prepared in "Audit Mode"
- image was finalized using sysprep
- system drive will be extended during first startup, you can use vagrant-disksize plugin
- hibernate mode disabled
- updates ( ${date} )
- drivers for kvm (viostor, netkvm, viorng, vioserial, qxldod, balloon)
- qemu|virtualbox|vmware guest agent
- winrm will be enabled over https during startup
- remote desktop allowed
- administrator account enabled

### Login Credentials
Username: Administrator \ vagrant

Password: vagrant