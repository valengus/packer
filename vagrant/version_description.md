### ${source.name} :

[source](https://github.com/valengus/packer.git)

- updates ( ${local.packerstarttime} )
- drivers for kvm (viostor, netkvm, viorng, vioserial, qxldod, balloon)
- qemu|virtualbox|vmware guest agent
- winrm enabled over https

### Login Credentials
Username: Administrator

Password: ${local.administrator_password}


Username: ${local.user}

Password: ${local.user_password}