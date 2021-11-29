variable "cloud_token" {
  type    = string
  default = "${env("CLOUD_TOKEN")}"
}

variable "iso_checksum" {
  type    = string
  default = "sha1:9cbbb18b244511bf1d4c68a33fe6ee35d2eda2ae"
}

variable "iso_url" {
  type    = string
  default = "https://tb.rg-adguard.net/dl.php?go=b1fb62af"
}

variable "winrm_password" {
  type    = string
  default = "password"
}

variable "winrm_username" {
  type    = string
  default = "Admin"
}

locals {
  packerstarttime = formatdate("YYYYMMDD", timestamp())
  version_description = <<EOF
### Clean and minimal Windows 11 PRO base box for libvirt with :

- chocolatey
- updates
- drivers (viostor, netkvm, viorng, vioserial, qxldod, balloon)
- qemu guest agent
- winrm enabled

### Login Credentials

Username: Admin

Password: password

EOF
}

source "qemu" "windows11" {
  accelerator         = "kvm"
  cd_files            = ["unattend/autounattend.xml", "scripts/*", "drivers/qemu/*"]
  communicator        = "winrm"
  cpus                = "2"
  disk_cache          = "writeback"
  disk_discard        = "ignore"
  disk_interface      = "virtio"
  disk_size           = "61440"
  format              = "qcow2"
  headless            = true
  iso_checksum        = "${var.iso_checksum}"
  iso_url             = "${var.iso_url}"
  memory              = "4096"
  shutdown_command     = "E:/packerShutdown.bat"
  shutdown_timeout    = "15m"
  use_default_display = false
  vm_name             = "windows11_${local.packerstarttime}"
  winrm_insecure      = "true"
  winrm_password      = "${var.winrm_password}"
  winrm_use_ssl       = false
  winrm_username      = "${var.winrm_username}"
}

source "virtualbox-iso" "windows11" {
  boot_wait            = "10s"
  cd_files             = ["scripts/*", "unattend/autounattend.xml"]
  communicator         = "winrm"
  cpus                 = 2
  disk_size            = 61440
  format               = "ova"
  guest_additions_mode = "disable"
  guest_os_type        = "Windows11_64"
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  keep_registered      = false
  memory               = 4096
  post_shutdown_delay  = "5m"
  shutdown_command     = "E:/packerShutdown.bat"
  skip_export          = false
  vm_name             = "windows11_${local.packerstarttime}"
  winrm_insecure       = "true"
  winrm_password       = "${var.winrm_password}"
  winrm_use_ssl        = false
  winrm_username       = "${var.winrm_username}"
}

source "vmware-iso" "windows11" {
  boot_wait            = "10s"
  cd_files             = ["scripts/*", "unattend/autounattend.xml", "drivers/vmware/*"]
  communicator         = "winrm"
  cpus                 = 2
  disk_adapter_type    = "pvscsi"
  disk_size            = 61440
  disk_type_id         = 0
  format               = "ova"
  guest_os_type        = "windows9-64"
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  keep_registered      = false
  memory               = 4096
  network_adapter_type = "e1000e"
  shutdown_command     = "E:/packerShutdown.bat"
  skip_export          = false
  vm_name              = "windows11_${local.packerstarttime}"
  winrm_insecure       = "true"
  winrm_password       = "${var.winrm_password}"
  winrm_use_ssl        = false
  winrm_username       = "${var.winrm_username}"
}

build {

  sources = [
    "source.qemu.windows11", 
    "source.virtualbox-iso.windows11", 
    "source.vmware-iso.windows11"
  ]

  provisioner "powershell" {
    inline = ["Start-Sleep -Seconds 60"]
  }

  provisioner "ansible" {
    playbook_file = "ansible/main.yml"
    use_proxy     = false
    user          = "Admin"
  }

  provisioner "powershell" {
    inline = ["Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"]
  }

  provisioner "powershell" {
    inline = ["choco install sdelete -y"]
  }

  provisioner "powershell" {
    inline = [
      "Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase",
      "Dism.exe /online /Cleanup-Image /SPSuperseded",
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
    destination = "C:/Windows/Temp/unattend.xml"
    source      = "unattend/unattend.xml"
  }

  post-processors {

    post-processor "vagrant" {
      compression_level    = 9
      output               = "windows-11-pro-{{.Provider}}.box"
      vagrantfile_template = "vagrant/windows11.template"
    }

    post-processor "vagrant-cloud" {
      access_token        = var.cloud_token
      box_tag             = "valengus/windows-11-pro"
      version             = "1.0.${local.packerstarttime}"
      version_description = "${local.version_description}"
    }
    
  }

}