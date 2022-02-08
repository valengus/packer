variable "iso_checksum" {
  type    = string
  default = "sha1:30ff3cc3cdc05abf47489742e2e1b810d0003968"
}

variable "iso_url" {
  type    = string
  default = "https://tb.rg-adguard.net/dl.php?go=ba3275f9"
}

variable "cloud_token" {
  type    = string
  default = "${env("CLOUD_TOKEN")}"
}

locals {
  packerstarttime     = formatdate("YYYYMMDD", timestamp())
  name                = "windows-10"
  winrm_username      = "Administrator"
  winrm_password      = "password"
  version_description = <<-EOF
  ### Windows 10 Pro STANDARD box with :
  source : [https://github.com/valengus/packer](https://github.com/valengus/packer)

  - updates
  - chocolatey
  - drivers for kvm (viostor, netkvm, viorng, vioserial, qxldod, balloon)
  - qemu|virtualbox|vmware guest agent
  - winrm enabled over https
  - openssh

  ### Login Credentials

  Username: Administrator

  Password: password
  EOF
}

source "qemu" "windows-10-pro" {
  accelerator         = "kvm"
  cd_files            = ["unattend/${local.name}/autounattend.xml", "scripts/*", "drivers/qemu/*"]
  communicator        = "winrm"
  cpus                = "2"
  disk_cache          = "writeback"
  disk_discard        = "ignore"
  disk_interface      = "virtio"
  disk_size           = "61440"
  format              = "qcow2"
  headless            = true
  vnc_bind_address    = "0.0.0.0"
  iso_checksum        = "${var.iso_checksum}"
  iso_url             = "${var.iso_url}"
  memory              = "4096"
  shutdown_command    = "C:\\Windows\\Temp\\packerShutdown.bat"
  shutdown_timeout    = "15m"
  use_default_display = false
  vm_name             = "${local.name}_${local.packerstarttime}"
  winrm_timeout       = "60m"
  winrm_insecure      = true
  winrm_use_ssl       = false
  winrm_password      = "${local.winrm_password}"
  winrm_username      = "${local.winrm_username}"
}


build {

  sources = [
    "source.qemu.windows-10-pro",
  ]

  provisioner "powershell" {
    inline = ["Start-Sleep -Seconds 120"]
  }

  provisioner "ansible" {
    playbook_file = "ansible/main.yml"
    use_proxy     = false
    user          = "${local.winrm_username}"
  }

  provisioner "powershell" {
    inline = ["Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"]
  }

  provisioner "powershell" {
    inline = ["choco install sdelete -y"]
  }

  provisioner "powershell" {
    inline = [
      "Optimize-Volume -DriveLetter C -Defrag",
      "sdelete -z c:",
    ]
  }

  provisioner "powershell" {
    inline = ["Set-Service -Name sshd -StartupType Automatic"]
  }

  provisioner "file" {
    destination = "C:/scripts/ConfigureRemotingForAnsible.ps1"
    source      = "scripts/ConfigureRemotingForAnsible.ps1"
  }

  provisioner "file" {
    destination = "C:/Windows/Temp/packerShutdown.bat"
    source      = "scripts/packerShutdown.bat"
  }

  provisioner "file" {
    destination = "C:/Windows/Temp/unattend.xml"
    source      = "unattend/unattend.xml"
  }

  post-processors {

    post-processor "vagrant" {
      compression_level    = 9
      output               = "${local.name}-{{.Provider}}.box"
      vagrantfile_template = "vagrant/windows.template"
    }

  }

}