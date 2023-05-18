variable "cloud_token" {
  type    = string
  default = "${env("CLOUD_TOKEN")}"
}

variable "headless" {
  type    = bool
  default = true
}

variable "cpus" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 4096
}

locals {
  # packerstarttime    = formatdate("YYYYMMDD", timestamp())
  packerstarttime    = "20230518"
  cpus                    = "${var.cpus}"
  memory                  = "${var.memory}"
  disk_size               = 20480
  headless                = "${var.headless}"
}

source "qemu" "fedora38" {
  iso_url            = "https://fedora.ip-connect.info/linux/releases/38/Server/x86_64/iso/Fedora-Server-netinst-x86_64-38-1.6.iso"
  iso_checksum       = "sha256:192af621553aa32154697029e34cbe30152a9e23d72d55f31918b166979bbcf5"
  shutdown_command   = "sudo systemctl poweroff"
  headless              = "${local.headless}"  
  cpus                  = "${local.cpus}"
  memory                = "${local.memory}"
  disk_size             = "${local.disk_size}"
  accelerator        = "kvm"
  http_directory     = "unattend"
  ssh_username       = "vagrant"
  ssh_password       = "vagrant"
  ssh_timeout        = "3600s"
  disk_interface     = "virtio"
  disk_cache         = "writeback"
  disk_discard       = "ignore"
  disk_detect_zeroes = "unmap"
  disk_compression   = true
  format             = "qcow2"
  net_device         = "virtio-net"
  qemu_binary        = ""
  vm_name            = "${source.name}"
  output_directory  = "output/qemu_${source.name}"
  boot_wait          = "5s"
  boot_command       =  [ "<up><wait>e<wait><down><down><leftCtrlOn>e<leftCtrlOff> biosdevname=0 net.ifnames=0 inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${source.name}.ks<f10>" ]
}

source "virtualbox-iso" "fedora38" {
  format               = "ova"
  iso_url              = "https://fedora.ip-connect.info/linux/releases/38/Server/x86_64/iso/Fedora-Server-netinst-x86_64-38-1.6.iso"
  iso_checksum         = "sha256:192af621553aa32154697029e34cbe30152a9e23d72d55f31918b166979bbcf5"
  headless              = "${local.headless}"  
  cpus                  = "${local.cpus}"
  memory                = "${local.memory}"
  disk_size             = "${local.disk_size}"
  boot_command       =  [ "<up><wait>e<wait><down><down><leftCtrlOn>e<leftCtrlOff> biosdevname=0 net.ifnames=0 inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${source.name}.ks<f10>" ]
  boot_wait            = "5s"
  http_directory       = "unattend"
  guest_os_type        = "Fedora_64"
  shutdown_command     = "sudo systemctl poweroff"
  ssh_username         = "vagrant"
  ssh_password         = "vagrant"
  ssh_timeout          = "3600s"
  # hard_drive_interface = "sata"
  output_directory  = "output/virtualbox-iso_${source.name}"
  keep_registered       = true
  skip_export           = true 
  vboxmanage_post = [
    ["modifyvm", "{{.Name}}", "--memory", "2048"],
    ["modifyvm", "{{.Name}}", "--cpus", "1"]
  ]
}


build {
  sources = [
    "sources.qemu.fedora38",
    "sources.virtualbox-iso.fedora38",
  ]

  provisioner "shell" {
      inline = ["sudo dnf update -y", "sudo dnf clean all"]
  }

  post-processors {

    post-processor "vagrant" {
      compression_level    = 9
      output               = "${source.name}-${source.type}.box"
      vagrantfile_template = "vagrant/linux.template"
    }

    post-processor "shell-local" {
      inline = ["vagrant box add --force ${source.name} ${source.name}-${source.type}.box"]
    }

    post-processor "shell-local" {
      inline = [ 
        "bash -c \"if [[ $PACKER_BUILDER_TYPE == 'qemu' ]]; then vagrant up ${source.name} --provider=libvirt ; fi\"",
        "bash -c \"if [[ $PACKER_BUILDER_TYPE == 'virtualbox-iso' ]]; then vagrant up ${source.name} --provider=virtualbox ; fi\"",
        "bash -c \"if [[ $PACKER_BUILDER_TYPE == 'vmware-iso' ]]; then vagrant up ${source.name} --provider=vmware_desktop ; fi\""
      ]
    }

    post-processor "shell-local" {
      inline = ["vagrant destroy -f"]
    }

    # post-processor "vagrant-cloud" {
    #   access_token        = "${var.cloud_token}"
    #   box_tag             = "valengus/${source.name}"
    #   version             = "38.1.6.${local.packerstarttime}"
    #   no_release          = true
    #   version_description = templatefile("${path.root}/vagrant/${source.name}/version_description.md", { 
    #     date = formatdate("DD.MM.YYYY", timestamp())
    #   } )
    # }

  }

}